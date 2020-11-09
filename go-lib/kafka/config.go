package kafka

import "time"

type KafkaConfig struct {
	Host         string        `mapstructure:"host"`
	Port         int           `mapstructure:"port"`
	Brokers      []string      `mapstructure:"brokers"`
	Partition    int           `mapstructure:"partition"`
	WriteTimeout time.Duration `mapstructure:"write_timeout"`
	Topic        string        `mapstructure:"topic"`
}
