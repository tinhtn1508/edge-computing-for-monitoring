package core

import (
	"encoding/json"
	"fmt"
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
type RedisSetFunction func(string, string) error

// RedisGetFunction ...
type RedisGetFunction func(string, redis.RedisGetPostProcessingFunction) (string, error)

// SlackSendFunction ...
type SlackSendFunction func(string, string, string) error

// CoreErrorConsumerConf ...
type CoreErrorConsumerConf struct {
	Log            *zap.SugaredLogger
	RedisSetFunc   RedisSetFunction
	RedisGetFunc   RedisGetFunction
	ContactURL     string
	ContactTimeout time.Duration
	SlackSendFunc  SlackSendFunction
	SlackChannel   string
}

type coreErrorConsumer struct {
	log           *zap.SugaredLogger
	redisSetFunc  RedisSetFunction
	redisGetFunc  RedisGetFunction
	contactClient httpclient.IHttpClient
	stopChannel   chan bool
	messChannel   chan *types.KeyValuePair
	wg            *sync.WaitGroup
	slackSendFunc SlackSendFunction
	slackChannel  string
	messTemplate  string
}

// NewCoreErrorConsumer ...
func NewCoreErrorConsumer(cfg CoreErrorConsumerConf) ICoreProcessor {
	instance := &coreErrorConsumer{}
	instance.log = cfg.Log
	instance.redisSetFunc = cfg.RedisSetFunc
	instance.redisGetFunc = cfg.RedisGetFunc
	instance.contactClient = httpclient.NewHttpClient(cfg.ContactURL, cfg.ContactTimeout, instance.contactHandler)
	instance.stopChannel = make(chan bool)
	instance.messChannel = make(chan *types.KeyValuePair)
	instance.wg = &sync.WaitGroup{}
	instance.slackSendFunc = cfg.SlackSendFunc
	instance.slackChannel = cfg.SlackChannel
	return instance
}

func (c *coreErrorConsumer) contactHandler(statusCode int, body []byte) bool {
	var contact catalogtype.GetContactResponse
	if err := json.Unmarshal(body, &contact); err != nil {
		c.log.Errorf("Malformed contact: %s / Error: %s", body, err)
		return false
	}

	for i := 0; i < len(contact); i++ {
		c.log.Infof("*************** Name: %s", contact[i].Name)
		mess := fmt.Sprintf("%s %s, Please to check now ?", c.messTemplate)
		if err := c.slackSendFunc(c.slackChannel, mess, contact[i].Email); err != nil {
			c.log.Errorf("Cannot send to slack bot, err: %s", err)
		}
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
				errorReportTable := &types.SensorErrorReportTable{}
				if err := json.Unmarshal(pair.Value, errorReportTable); err != nil {
					c.log.Errorf("Malformed number: %s / Error: %s", pair.Value, err)
					continue
				}

				for _, v := range *errorReportTable {
					redisKey := v.EdgeNode + v.Sensor
					if ret, _ := c.redisGetFunc(redisKey, nil); len(ret) == 0 {
						c.log.Infof("------------------------------------------------------------")
						c.log.Infof("---------------------- [ALERT] -----------------------------")
						params := &url.Values{}
						params.Add("edgenode", v.EdgeNode)
						params.Add("sensor", v.Sensor)
						c.messTemplate = fmt.Sprintf("[ERROR] Problem: %s, from %s and %s\n", v.Describes, v.EdgeNode, v.Sensor)
						if err := c.contactClient.DoGetJson(params); err != nil {
							c.log.Errorf("Error while getting contact: %s", err)
						}
						if err := c.redisSetFunc(redisKey, "active"); err != nil {
							c.log.Errorf("Error while setting redis: %s", err)
						}
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
