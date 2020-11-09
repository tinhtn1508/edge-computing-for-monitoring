package core

import (
	"sync"

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
				c.log.Infof("key ne fence: %s --- value ne: %s", pair.Key, pair.Value)
				c.log.Infof("Fence xu ly message o day roi gui no len influxdb nghen. Minh dung cai c.writepoint de gui nghen")
			}
		}
	}()
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
