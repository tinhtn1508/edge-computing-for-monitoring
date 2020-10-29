package kafka

import (
	"context"
	"fmt"
	"time"

	kafka "github.com/segmentio/kafka-go"
	"go.uber.org/zap"
)

// KafkaConfig is used to config for Kafka connection instances
type KafkaConfig struct {
	Host          string   `mapstructure:"host"`
	Port          int      `mapstructure:"port"`
	Brokers       []string `mapstructure:"brokers"`
	DialerTimeout int      `mapstructure:"dialer-timeout"`
	WriteTimeout  int      `mapstructure:"write-timeout"`
	ReadTimeout   int      `mapstructure:"read-timeout"`
}

type IProducer interface {
	Start() error
	Stop()
	Produce(key []byte, value []byte) error
}

type SimpleProducerConfig struct {
	Log       *zap.SugaredLogger
	Ctx       context.Context
	Topic     string
	Brokers   []string
	Batchsize int
	Timeout   time.Duration
}

type SimpleProducer struct {
	log       *zap.SugaredLogger
	ctx       context.Context
	topic     string
	brokers   []string
	batchsize int
	writter   *kafka.Writer
	timeout   time.Duration
}

func NewSimpleProducer(cfg SimpleProducerConfig) IProducer {
	return &SimpleProducer{
		log:       cfg.Log,
		ctx:       cfg.Ctx,
		topic:     cfg.Topic,
		brokers:   cfg.Brokers,
		batchsize: cfg.Batchsize,
		timeout:   cfg.Timeout,
	}
}

func (p *SimpleProducer) Start() error {
	p.writter = kafka.NewWriter(
		kafka.WriterConfig{
			Brokers:   p.brokers,
			Topic:     p.topic,
			Balancer:  &kafka.LeastBytes{},
			BatchSize: p.batchsize,
		},
	)
	if p.writter == nil {
		return fmt.Errorf("Error while creating kafka writter")
	}
	return nil
}

func (p *SimpleProducer) Stop() {
	if p.writter != nil {
		p.log.Infof("Writter stats: %+v", p.writter.Stats())
		p.writter.Close()
		p.writter = nil
	}
}

func (p *SimpleProducer) Produce(key []byte, value []byte) error {
	if p.writter == nil {
		return fmt.Errorf("Writter haven't been initialzed, call Start() first")
	}

	timeoutCtx, cancel := context.WithTimeout(p.ctx, p.timeout)
	defer cancel()

	p.log.Debugf("Write message: %s --- %s to topic %s", key, value, p.topic)
	return p.writter.WriteMessages(timeoutCtx, kafka.Message{
		Key:   key,
		Value: value,
	})
}
