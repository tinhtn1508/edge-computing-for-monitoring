package core

import (
	"encoding/json"
	"strings"
	"sync"
	"time"

	influxdb "github.com/influxdata/influxdb/client/v2"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/types"
	"go.uber.org/zap"
)

type WriteInfluxPointFunc func(info *influxdb.Point) error

type CoreProcessorConfig struct {
	Log            *zap.SugaredLogger
	WritePointFunc WriteInfluxPointFunc
}

type ICoreProcessor interface {
	Start()
	Stop()
	HandleMessage([]byte, []byte) bool
}

type core struct {
	log         *zap.SugaredLogger
	writepoint  WriteInfluxPointFunc
	messChannel chan *types.KeyValuePair
	stopChannel chan bool
	wg          *sync.WaitGroup
}

func NewCoreProcessor(cfg CoreProcessorConfig) ICoreProcessor {
	return &core{
		log:         cfg.Log,
		writepoint:  cfg.WritePointFunc,
		messChannel: make(chan *types.KeyValuePair, 100),
		stopChannel: make(chan bool),
		wg:          &sync.WaitGroup{},
	}
}

func (c *core) Start() {
	go func() {
		c.wg.Add(1)
		for {
			select {
			case <-c.stopChannel:
				return
			case pair := <-c.messChannel:
				signalSensorTable := &types.SensorSignalTable{}
				if err := json.Unmarshal(pair.Value, signalSensorTable); err != nil {
					c.log.Errorf("Malformed number: %s / Error: %s", pair.Value, err)
					return
				}

				for k, v := range *signalSensorTable {
					measurement, tags := c._parseInfluxInfo(string(pair.Key), k)
					if measurement != "" && tags != nil {
						if point, err := influxdb.NewPoint(
							measurement,
							tags,
							map[string]interface{}{
								"value": v.Value,
							},
							time.Unix(0, int64(v.TimeStamp)),
						); err != nil {
							c.log.Errorf("Error while create a new point, %w", err)
						} else {
							c.writepoint(point)
						}
					}
				}
			}
		}
	}()
}

func (c *core) _parseInfluxInfo(keyKafka string, keySignalSensor string) (string, map[string]string) {
	params := strings.Split(keyKafka, ".")
	if len(params) != 2 {
		c.log.Errorf("Incorret key format, %s", keyKafka)
		return "", nil
	}

	p := strings.Split(keySignalSensor, ".")
	if len(p) != 3 {
		c.log.Errorf("Incorret key format, %s", keySignalSensor)
		return "", nil
	}
	return p[0], map[string]string{"edge-node": params[0], p[1]: p[2]}
}

func (c *core) Stop() {
	c.stopChannel <- true
	c.wg.Wait()
}

func (c *core) HandleMessage(key []byte, value []byte) bool {
	pair := &types.KeyValuePair{
		Key:   key,
		Value: value,
	}
	c.messChannel <- pair
	return true
}
