package core

import (
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	influxdb "github.com/influxdata/influxdb/client/v2"
	"go.uber.org/zap"

	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/types"
	influxdblib "github.com/tinhtn1508/edge-computing-for-monitor/go-lib/influxdb"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/rmq"
)

type PublishFunc func([]byte, []byte) error

type Record struct {
	AppID     string
	Timestamp time.Time
	Body      []byte
}

type CoreConfig struct {
	RecordLifeTime  time.Duration `mapstructure:"record-lifetime"`
	CollectInterval time.Duration `mapstructure:"collect-interval"`
}

type CoreProcessorConfig struct {
	Log             *zap.SugaredLogger
	CoreConfig      CoreConfig
	PublishCallback PublishFunc
	InfluxDBWriter  influxdblib.IWriter
	InfoKey         string
}

type ICoreProcessor interface {
	Start()
	Stop()
	AddConsumingTask(string) (rmq.DataConsumeFunc, error)
	GetHandlerMap() map[string]rmq.DataConsumeFunc
}

type CoreProcessor struct {
	sync.RWMutex
	log             *zap.SugaredLogger
	stopChannel     chan bool
	wg              *sync.WaitGroup
	recordLifetime  time.Duration
	collectInterval time.Duration
	handlerTable    map[string]rmq.DataConsumeFunc
	recordTable     map[string]Record
	publishFunc     PublishFunc
	writer          influxdblib.IWriter
	infoKey         string
}

func NewCoreProcessor(cfg CoreProcessorConfig) ICoreProcessor {
	return &CoreProcessor{
		log:             cfg.Log,
		stopChannel:     make(chan bool),
		wg:              &sync.WaitGroup{},
		recordLifetime:  cfg.CoreConfig.RecordLifeTime,
		collectInterval: cfg.CoreConfig.CollectInterval,
		handlerTable:    make(map[string]rmq.DataConsumeFunc),
		recordTable:     make(map[string]Record),
		publishFunc:     cfg.PublishCallback,
		infoKey:         cfg.InfoKey,
		writer:          cfg.InfluxDBWriter,
	}
}

func (p *CoreProcessor) collect() {
	p.RLock()
	defer p.RUnlock()
	p.log.Infof("dang collect ne")
	aggregated := make(map[string]*types.SensorSignal)
	for k, v := range p.recordTable {
		if v.Timestamp.Add(p.recordLifetime).Unix() < time.Now().Unix() {
			p.log.Errorf("Cai record nay (%s) --- %+v --- expire nha", k, v)
		} else {
			p.log.Infof("Cai record nay (%s) valid ne: %+v", k, v)
			signal := &types.SensorSignal{}
			if err := json.Unmarshal(v.Body, signal); err == nil {
				aggregated[k] = signal
			} else {
				p.log.Errorf("Malformed number: %s / Error: %s", v.Body, err)
			}
		}
	}
	if bjson, err := json.Marshal(aggregated); err != nil {
		p.log.Errorf("Cannot produce json for %+v / Error: %s", aggregated, err)
	} else if p.publishFunc != nil {
		p.publishFunc([]byte(fmt.Sprintf("%s-%d", p.infoKey, time.Now().Unix())), bjson)
	}
	p.log.Infof("can phai aggregate info ne")
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
			case <-p.stopChannel:
				return
			}
		}
	}()
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
		p.Lock()
		defer p.Unlock()
		p.recordTable[key] = Record{
			appid, t, body,
		}

		data := &types.SensorSignal{}
		if err := json.Unmarshal(body, data); err != nil {
			return fmt.Errorf("Malformed number: %s / Error: %s", body, err)
		}

		measurement, tags := p._parseInfluxInfo(key)

		if measurement != "" && tags != nil {
			if point, err := influxdb.NewPoint(
				measurement,
				tags,
				map[string]interface{}{
					"value": data.Value,
				},
				time.Unix(0, int64(data.TimeStamp)),
			); err != nil {
				return fmt.Errorf("Error while create a new point, %w", err)
			} else {
				p.writer.Write(point)
			}
		}
		return nil
	}

	p.handlerTable[key] = handler

	return handler, nil
}

func (p *CoreProcessor) GetHandlerMap() map[string]rmq.DataConsumeFunc {
	return p.handlerTable
}
