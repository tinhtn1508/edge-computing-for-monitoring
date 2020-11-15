package core

import (
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	influxdb "github.com/influxdata/influxdb/client/v2"
	"go.uber.org/zap"

	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/rmq"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/types"
)

type PublishFunc func([]byte, []byte) error
type WriteInfluxPointFunc func(info *influxdb.Point) error

type Record struct {
	AppID     string
	Timestamp time.Time
	Data      types.SensorSignal
}

type ListRecord []Record

type ComsumeData struct {
	Key   string
	Appid string
	Time  time.Time
	Body  []byte
}

type SensorSafeRange struct {
	Name  string
	Upper float64
	Lower float64
}

type CoreConfig struct {
	RecordLifeTime  time.Duration     `mapstructure:"record-lifetime"`
	CollectInterval time.Duration     `mapstructure:"collect-interval"`
	Limit           []SensorSafeRange `mapstructure:"limit"`
}

type CoreProcessorConfig struct {
	Log                 *zap.SugaredLogger
	CoreConfig          CoreConfig
	PublishCallback     PublishFunc
	ErrorReportCallback PublishFunc
	WritePoint          WriteInfluxPointFunc
	InfoKey             string
	EdgeNodeName        string
}

type ICoreProcessor interface {
	Start()
	Stop()
	AddConsumingTask(string) (rmq.DataConsumeFunc, error)
	GetHandlerMap() map[string]rmq.DataConsumeFunc
}

type CoreProcessor struct {
	log              *zap.SugaredLogger
	stopChannel      chan bool
	wg               *sync.WaitGroup
	recordLifetime   time.Duration
	collectInterval  time.Duration
	handlerTable     map[string]rmq.DataConsumeFunc
	recordTable      map[string]ListRecord
	recordChan       chan ComsumeData
	publishFunc      PublishFunc
	errReportFunc    PublishFunc
	writepoint       WriteInfluxPointFunc
	infoKey          string
	edgeNodeName     string
	sensorSafeRanges []SensorSafeRange
}

func NewCoreProcessor(cfg CoreProcessorConfig) ICoreProcessor {
	return &CoreProcessor{
		log:              cfg.Log,
		stopChannel:      make(chan bool),
		wg:               &sync.WaitGroup{},
		recordLifetime:   cfg.CoreConfig.RecordLifeTime,
		collectInterval:  cfg.CoreConfig.CollectInterval,
		handlerTable:     make(map[string]rmq.DataConsumeFunc),
		recordTable:      make(map[string]ListRecord),
		recordChan:       make(chan ComsumeData, 10),
		publishFunc:      cfg.PublishCallback,
		errReportFunc:    cfg.ErrorReportCallback,
		infoKey:          cfg.InfoKey,
		writepoint:       cfg.WritePoint,
		edgeNodeName:     cfg.EdgeNodeName,
		sensorSafeRanges: cfg.CoreConfig.Limit,
	}
}

func (p *CoreProcessor) _movingAverage(key string, data ListRecord) *types.SensorSignal {
	if data == nil {
		return nil
	}

	var sumTime uint64
	var num uint64
	var sumValue float64
	for _, record := range data {
		if record.Timestamp.Add(p.recordLifetime).Unix() < time.Now().Unix() {
			p.log.Errorf("Record (%s) --- %+v --- expire !!!!!!!!!!!", key, record)
			continue
		}
		num++
		sumTime += record.Data.TimeStamp
		sumValue += record.Data.Value
	}
	return &types.SensorSignal{sumTime / num, sumValue / float64(num)}
}

func (p *CoreProcessor) collect() {
	aggregated := make(types.SensorSignalTable)
	errorTable := make(map[string]*types.ErrorReport)
	boundRangeTable := make(map[string]*types.ErrorReport)

	boundRangeAdder := func(key string, averageRecord *types.SensorSignal) {
		name := strings.Split(key, ".")[2]
		for _, e := range p.sensorSafeRanges {
			if e.Name == name {
				if averageRecord.Value > e.Upper {
					boundRangeTable[key] = &types.ErrorReport{
						EdgeNode:  p.edgeNodeName,
						Sensor:    name,
						Time:      time.Unix(0, int64(averageRecord.TimeStamp)),
						Describes: "Upper Error",
					}
				} else if averageRecord.Value < e.Lower {
					boundRangeTable[key] = &types.ErrorReport{
						EdgeNode:  p.edgeNodeName,
						Sensor:    name,
						Time:      time.Unix(0, int64(averageRecord.TimeStamp)),
						Describes: "Lower Error",
					}
				}
			}
		}
	}

	for key, records := range p.recordTable {
		averageRecord := p._movingAverage(key, records)
		if averageRecord == nil {
			errorTable[key] = &types.ErrorReport{
				EdgeNode:  p.edgeNodeName,
				Sensor:    strings.Split(key, ".")[2],
				Time:      time.Now(),
				Describes: "Lost connection",
			}
		} else {
			boundRangeAdder(key, averageRecord)
			aggregated[key] = averageRecord
		}
	}

	if bjson, err := json.Marshal(aggregated); err != nil {
		p.log.Errorf("Cannot produce json for %+v / Error: %s", aggregated, err)
	} else if p.publishFunc != nil && len(aggregated) > 0 {
		p.publishFunc([]byte(fmt.Sprintf("%s.%d", p.edgeNodeName, time.Now().Unix())), bjson)
	}

	if bjson, err := json.Marshal(errorTable); err != nil {
		p.log.Errorf("Cannot produce json for %+v / Error: %s", errorTable, err)
	} else if p.errReportFunc != nil && len(errorTable) > 0 {
		p.errReportFunc([]byte(fmt.Sprintf("%s.%d", p.edgeNodeName, time.Now().Unix())), bjson)
	}

	if bjson, err := json.Marshal(boundRangeTable); err != nil {
		p.log.Errorf("Cannot produce json for %+v / Error: %s", boundRangeTable, err)
	} else if p.errReportFunc != nil && len(boundRangeTable) > 0 {
		p.errReportFunc([]byte(fmt.Sprintf("%s.%d", p.edgeNodeName, time.Now().Unix())), bjson)
	}

	for key := range p.recordTable {
		p.recordTable[key] = nil
	}
}

func (p *CoreProcessor) _parseInfluxInfo(key string) (string, map[string]string) {
	params := strings.Split(key, ".")
	if len(params) != 3 {
		p.log.Errorf("Incorret key format, %s", key)
		return "", nil
	}
	return params[0], map[string]string{params[1]: params[2]}
}

func (p *CoreProcessor) Start() {
	go func() {
		p.wg.Add(1)
		defer p.wg.Done()
		ticker := time.NewTicker(p.collectInterval)
		for {
			select {
			case <-ticker.C:
				p.collect()
			case record := <-p.recordChan:
				p._comsumeWorker(record)
			case <-p.stopChannel:
				return
			}
		}
	}()
}

func (p *CoreProcessor) _comsumeWorker(d ComsumeData) {
	data := &types.SensorSignal{}
	if err := json.Unmarshal(d.Body, data); err != nil {
		p.log.Errorf("Malformed number: %s / Error: %s", d.Body, err)
		return
	}
	p.recordTable[d.Key] = append(p.recordTable[d.Key], Record{
		d.Appid, d.Time, *data,
	})

	measurement, tags := p._parseInfluxInfo(d.Key)

	if measurement != "" && tags != nil {
		if point, err := influxdb.NewPoint(
			measurement,
			tags,
			map[string]interface{}{
				"value": data.Value,
			},
			time.Unix(0, int64(data.TimeStamp)),
		); err != nil {
			p.log.Errorf("Error while create a new point, %w", err)
			return
		} else {
			p.writepoint(point)
		}
	}
}

func (p *CoreProcessor) Stop() {
	p.stopChannel <- true
	p.wg.Wait()
}

func (p *CoreProcessor) AddConsumingTask(key string) (rmq.DataConsumeFunc, error) {
	if _, found := p.handlerTable[key]; found {
		return nil, fmt.Errorf("Key (%s) have to be unique", key)
	}

	handler := func(appid string, t time.Time, body []byte) error {
		p.recordChan <- ComsumeData{
			Key:   key,
			Appid: appid,
			Time:  t,
			Body:  body,
		}
		return nil
	}
	p.handlerTable[key] = handler

	return handler, nil
}

func (p *CoreProcessor) GetHandlerMap() map[string]rmq.DataConsumeFunc {
	return p.handlerTable
}
