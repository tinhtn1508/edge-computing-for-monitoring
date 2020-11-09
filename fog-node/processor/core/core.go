package core

import (
	"sync"

	influxdb "github.com/influxdata/influxdb/client/v2"
	"go.uber.org/zap"
)

type WriteInfluxPointFunc func(info *influxdb.Point) error

type CoreProcessorConfig struct {
	Log            *zap.SugaredLogger
	WritePointFunc WriteInfluxPointFunc
}

type ICoreProcessor interface {
	Start() error
	Stop()
	HandleMessage([]byte, []byte) bool
}

type container struct {
	key   []byte
	value []byte
}

type core struct {
	log         *zap.SugaredLogger
	writepoint  WriteInfluxPointFunc
	messChannel chan *container
	stopChannel chan bool
	wg          *sync.WaitGroup
}

func NewCoreProcessor(cfg CoreProcessorConfig) ICoreProcessor {
	return &core{
		log:         cfg.Log,
		writepoint:  cfg.WritePointFunc,
		messChannel: make(chan *container, 100),
		stopChannel: make(chan bool),
		wg:          &sync.WaitGroup{},
	}
}

func (c *core) Start() error {
	return nil
}

func (c *core) Stop() {
	c.stopChannel <- true
	c.wg.Wait()
}

func (c *core) HandleMessage(key []byte, value []byte) bool {
	return true
}
