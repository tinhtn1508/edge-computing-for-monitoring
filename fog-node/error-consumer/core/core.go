package core

import (
	"encoding/json"
	"net/url"
	"sync"
	"time"

	catalogtype "github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/types"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/httpclient"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/redis"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/types"
	"go.uber.org/zap"
)

// ICoreProcessor ...
type ICoreProcessor interface {
	Start()
	Stop()
	HandleMessage([]byte, []byte) bool
}

// RedisSetFunction ...
type RedisSetFunction func (string, string) error
// RedisGetFunction ...
type RedisGetFunction func (string, redis.RedisGetPostProcessingFunction) (string, error)

// CoreErrorConsumerConf ...
type CoreErrorConsumerConf struct {
	Log            *zap.SugaredLogger
	RedisSetFunc   RedisSetFunction
	RedisGetFunc   RedisGetFunction
	ContactURL	   string
	ContactTimeout time.Duration
} 

type coreErrorConsumer struct {
	log           *zap.SugaredLogger
	redisSetFunc  RedisSetFunction
	redisGetFunc  RedisGetFunction
	contactClient httpclient.IHttpClient
	stopChannel   chan bool
	messChannel   chan *types.KeyValuePair
	wg            *sync.WaitGroup

}

// NewCoreErrorConsumer ...
func NewCoreErrorConsumer(cfg CoreErrorConsumerConf) ICoreProcessor {
	instance := &coreErrorConsumer{}
	instance.log 		   = cfg.Log
	instance.redisSetFunc  = cfg.RedisSetFunc
	instance.redisGetFunc  = cfg.RedisGetFunc
	instance.contactClient = httpclient.NewHttpClient(cfg.ContactURL, cfg.ContactTimeout, instance.contactHandler)
	instance.stopChannel   = make(chan bool)
	instance.messChannel   = make(chan *types.KeyValuePair)
	instance.wg            = &sync.WaitGroup{}
	return instance
}

func (c *coreErrorConsumer) contactHandler(statusCode int, body []byte) bool {
	contact := make(catalogtype.GetContactResponse, 0)
	if err := json.Unmarshal(body, contact); err != nil {
		c.log.Errorf("Malformed contact: %s / Error: %s", body, err)
		return false
	}

	for i := 0; i < len(contact); i++ {
		c.log.Infof("*************** Name: %s", contact[i].Name)
	}
	return true
}

func (c *coreErrorConsumer) Start() {
	go func() {
		c.wg.Add(1)
		for {
			select {
			case <-c.stopChannel:
				return
			case pair := <-c.messChannel:
				errorReport := &types.ErrorReport{}
				if err := json.Unmarshal(pair.Value, errorReport); err != nil {
					c.log.Errorf("Malformed number: %s / Error: %s", pair.Value, err)
					return
				}

				redisKey := errorReport.EdgeNode + errorReport.Sensor
				if ret, _ := c.redisGetFunc(redisKey, nil); len(ret) == 0 {
					c.log.Infof("------------------------------------------------------------")
					c.log.Infof("---------------------- [ALERT] -----------------------------")
					params := &url.Values{}
					params.Add("edgenode", errorReport.EdgeNode)
					params.Add("sensor", errorReport.Sensor)
					if err := c.contactClient.DoGetJson(params); err != nil {
						c.log.Errorf("Error while getting contact: %s", err)
					}

					if err := c.redisSetFunc(redisKey, "active"); err != nil {
						c.log.Errorf("Error while setting redis: %s", err)
					}
				}
			}
		}
	}()
}

func (c *coreErrorConsumer) Stop() {
	c.stopChannel <- true
	c.wg.Wait()
}

func (c *coreErrorConsumer) HandleMessage(key []byte, value []byte) bool {
	pair := &types.KeyValuePair{
		Key:   key,
		Value: value,
	}
	c.messChannel <- pair
	return true
}
