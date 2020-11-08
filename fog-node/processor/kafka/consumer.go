package kafka

import (
	"context"
	"fmt"
	"time"

	kafka "github.com/segmentio/kafka-go"
	"go.uber.org/zap"
)

// ConsumingFunction represents a function for consumming messages
type ConsumingFunction func([]byte, []byte) bool

// IConsumer represent an interface of consumer
type IConsumer interface {
	Init() error
	StartConsuming() error
	StopConsuming()
	Destroy()
}

// GeneralConsumerDeps config for a GeneralConsumer
type GeneralConsumerDeps struct {
	Log           *zap.SugaredLogger
	Ctx           context.Context
	Topic         string
	Brokers       []string
	Partition     int
	Offset        int64
	SleepInterval int
	ReadTimeout   int
	Consume       ConsumingFunction
}

// GeneralConsumer is a backbone to build a consumer
type GeneralConsumer struct {
	log           *zap.SugaredLogger
	ctx           context.Context
	kafkaTopic    string
	brokers       []string
	partition     int
	offset        int64
	sleepInterval time.Duration
	readTimeout   time.Duration
	consume       ConsumingFunction
	reader        *kafka.Reader
	stopChannel   chan bool
}

// NewGeneralConsumer create a new GeneralConsumer
func NewGeneralConsumer(deps GeneralConsumerDeps) *GeneralConsumer {
	return &GeneralConsumer{
		log:           deps.Log,
		ctx:           deps.Ctx,
		kafkaTopic:    deps.Topic,
		brokers:       deps.Brokers,
		partition:     deps.Partition,
		offset:        deps.Offset,
		sleepInterval: time.Duration(deps.SleepInterval),
		readTimeout:   time.Duration(deps.ReadTimeout),
		consume:       deps.Consume,
	}
}

// Init inits a new consumer
func (c *GeneralConsumer) Init() error {
	c.reader = kafka.NewReader(kafka.ReaderConfig{
		Brokers:   c.brokers,
		Topic:     c.kafkaTopic,
		Partition: c.partition,
	})
	c.reader.SetOffset(c.offset)
	c.stopChannel = make(chan bool)
	return nil
}

// StartConsuming start the consumer to consume kafka message
func (c *GeneralConsumer) StartConsuming() error {
	if c.reader == nil {
		return fmt.Errorf("Kafka reader haven't been started, call Init() first")
	}
	ticker := time.NewTicker(c.sleepInterval * time.Second)
	go func() {
		for {
			select {
			case <-c.stopChannel:
				return
			case <-ticker.C:
				for {
					timeoutCtx, cancel := context.WithTimeout(c.ctx,
						c.readTimeout*time.Second,
					)
					defer cancel()
					msg, err := c.reader.ReadMessage(timeoutCtx)
					if err != nil {
						break
					}
					if !c.consume(msg.Key, msg.Value) {
						break
					}
				}
			}
		}
	}()
	return nil
}

// StopConsuming stops consumer from consuming kafka message
func (c *GeneralConsumer) StopConsuming() {
	if c.reader != nil {
		c.reader.Close()
		c.stopChannel <- true
	}
}

// Destroy destroyes the object
func (c *GeneralConsumer) Destroy() {

}
