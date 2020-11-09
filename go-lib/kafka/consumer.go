package kafka

import (
	"context"
	"fmt"

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
	Log       *zap.SugaredLogger
	Ctx       context.Context
	Topic     string
	Brokers   []string
	Partition int
	Offset    int64
	Consume   ConsumingFunction
}

// GeneralConsumer is a backbone to build a consumer
type GeneralConsumer struct {
	log         *zap.SugaredLogger
	ctx         context.Context
	kafkaTopic  string
	brokers     []string
	partition   int
	offset      int64
	consume     ConsumingFunction
	reader      *kafka.Reader
	cancelFunc  context.CancelFunc
	stopChannel chan bool
}

// NewGeneralConsumer create a new GeneralConsumer
func NewGeneralConsumer(deps GeneralConsumerDeps) *GeneralConsumer {
	return &GeneralConsumer{
		log:        deps.Log,
		ctx:        deps.Ctx,
		kafkaTopic: deps.Topic,
		brokers:    deps.Brokers,
		partition:  deps.Partition,
		offset:     deps.Offset,
		consume:    deps.Consume,
	}
}

// Init inits a new consumer
func (c *GeneralConsumer) Init() error {
	c.reader = kafka.NewReader(kafka.ReaderConfig{
		Brokers:   c.brokers,
		Topic:     c.kafkaTopic,
		Partition: c.partition,
		MinBytes:  1,
		MaxBytes:  1000000,
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
	go func() {
		for {
			select {
			case <-c.stopChannel:
				return
			default:
				ctx, cancel := context.WithCancel(c.ctx)
				c.cancelFunc = cancel
				msg, err := c.reader.ReadMessage(ctx)
				if err != nil {
					continue
				}
				if !c.consume(msg.Key, msg.Value) {
					break
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
		if c.cancelFunc != nil {
			c.cancelFunc()
		}
	}
}

// Destroy destroyes the object
func (c *GeneralConsumer) Destroy() {

}
