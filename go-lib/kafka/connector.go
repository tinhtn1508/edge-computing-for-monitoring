package kafka

import (
	"context"
	"fmt"
	"strconv"
	"time"

	kafka "github.com/segmentio/kafka-go"
	"go.uber.org/zap"
)

type KafkaConnector interface {
	Open() error
	Close()
	GetApiVersions() ([]string, error)
	GetBrokers() ([]string, error)
	CreateTopics(string, int, int) error
}

type TcpKafkaConnectorDeps struct {
	Log     *zap.SugaredLogger
	Ctx     context.Context
	Timeout time.Duration
	Host    string
}

func NewTcpKafkaConnector(deps TcpKafkaConnectorDeps) KafkaConnector {
	return &tcpKafkaConnector{
		log:     deps.Log,
		ctx:     deps.Ctx,
		timeout: deps.Timeout,
		host:    deps.Host,
	}
}

type tcpKafkaConnector struct {
	log       *zap.SugaredLogger
	connector *kafka.Conn
	ctx       context.Context
	timeout   time.Duration
	host      string
}

func (kc *tcpKafkaConnector) Open() error {
	if kc.connector != nil {
		return fmt.Errorf("Connection have been initialized!")
	}

	timeoutCtx, cancel := context.WithTimeout(kc.ctx, kc.timeout)
	defer cancel()

	if conn, err := kafka.DialContext(timeoutCtx, "tcp", kc.host); err != nil {
		return fmt.Errorf("Error while initializing Kafka: %w", err)
	} else {
		kc.connector = conn
	}

	return nil
}

func (kc *tcpKafkaConnector) Close() {
	if kc.connector != nil {
		kc.connector.Close()
	}
}

func (kc *tcpKafkaConnector) GetApiVersions() ([]string, error) {
	if kc.connector == nil {
		return nil, fmt.Errorf("kafka connector haven't been initialized, call Open() first")
	}

	apiVersions, err := kc.connector.ApiVersions()
	if err != nil {
		return nil, fmt.Errorf("Error occurs while retrieving api versions: %w", err)
	}

	result := make([]string, 0)
	for _, apiVer := range apiVersions {
		result = append(result, strconv.Itoa(int(apiVer.ApiKey)))
	}

	return result, nil
}

func (kc *tcpKafkaConnector) GetBrokers() ([]string, error) {
	if kc.connector == nil {
		return nil, fmt.Errorf("kafka connector haven't been initialized, call Open() first")
	}

	brokers, err := kc.connector.Brokers()
	if err != nil {
		return nil, fmt.Errorf("Error occurs while retrieving brokers: %w", err)
	}

	result := make([]string, 0)
	for _, broker := range brokers {
		url := fmt.Sprintf("%s:%d", broker.Host, broker.Port)
		result = append(result, url)
	}

	return result, nil
}

func (kc *tcpKafkaConnector) CreateTopics(topicName string, partitions int, replicas int) error {
	if kc.connector == nil {
		return fmt.Errorf("kafka connector haven't been initialized, call Open() first")
	}

	kc.log.Infof("[Topic: %s] topic is created with %d replicas and %d partitions", topicName, replicas, partitions)

	return kc.connector.CreateTopics(kafka.TopicConfig{
		Topic:             topicName,
		NumPartitions:     partitions,
		ReplicationFactor: replicas,
	})
}
