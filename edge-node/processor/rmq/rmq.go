package rmq

import (
	"fmt"
	"sync"
	"time"

	"github.com/streadway/amqp"
	"go.uber.org/zap"
)

type DataConsumeFunc func(string, time.Time, []byte) error

// RabbitMQConfig is used to config for RMQ instances
type RabbitMQConfig struct {
	Host     string   `mapstructure:"host"`
	Port     int      `mapstructure:"port"`
	Username string   `mapstructure:"username"`
	Password string   `mapstructure:"password"`
	Exchange string   `mapstructure:"exchange"`
	Queues   []string `mapstructure:"queues"`
}

func (conf *RabbitMQConfig) GetUrl() string {
	return fmt.Sprintf("amqp://%s:%s@%s:%d/",
		conf.Username,
		conf.Password,
		conf.Host,
		conf.Port,
	)
}

type RabbitMQConsumerConfig struct {
	Log              *zap.SugaredLogger
	ServerURL        string
	Exchange         string
	QueuesProcessors map[string]DataConsumeFunc
}

type IConsumer interface {
	Start()
	Stop()
}

type TopicConsumer struct {
	log              *zap.SugaredLogger
	connection       *amqp.Connection
	channel          *amqp.Channel
	queuesProcessors map[string]DataConsumeFunc
	wg               *sync.WaitGroup
}

func NewTopicConsumer(cfg RabbitMQConsumerConfig) (IConsumer, error) {
	conn, err := amqp.Dial(cfg.ServerURL)
	if err != nil {
		return nil, err
	}

	channel, err := conn.Channel()
	if err != nil {
		return nil, err
	}

	if err := channel.ExchangeDeclare(
		cfg.Exchange, "topic", true, false, false, false, nil,
	); err != nil {
		return nil, err
	}

	for q := range cfg.QueuesProcessors {
		if _, err := channel.QueueDeclare(
			q, true, false, false, false, nil,
		); err != nil {
			cfg.Log.Fatalf("error occurs while creating queue: %s", err)
			continue
		}
	}

	return &TopicConsumer{
		log:              cfg.Log,
		connection:       conn,
		channel:          channel,
		queuesProcessors: cfg.QueuesProcessors,
		wg:               &sync.WaitGroup{},
	}, nil
}

func (c *TopicConsumer) consumingWorker(queue string, consume DataConsumeFunc) error {
	c.wg.Add(1)
	defer c.wg.Done()
	c.log.Infof("Start consuming from queue %s", queue)
	iter, err := c.channel.Consume(queue, fmt.Sprintf("%s-consumer", queue),
		false, false, false, false, nil,
	)
	if err != nil {
		return err
	}

	for message := range iter {
		if err := consume(message.AppId, message.Timestamp, message.Body); err != nil {
			c.log.Errorf("error occurs while consuming message from appid %s. Error = %s",
				message.AppId, err,
			)
		}
	}
	return nil
}

func (c *TopicConsumer) Start() {
	for q, f := range c.queuesProcessors {
		go c.consumingWorker(q, f)
	}
}

func (c *TopicConsumer) Stop() {
	for q := range c.queuesProcessors {
		if err := c.channel.Cancel(fmt.Sprintf("%s-consumer", q), true); err != nil {
			c.log.Fatalf("error while canceling consumer %s", q)
		}
	}
	c.wg.Wait()
}
