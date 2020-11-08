package kafka

import "time"

type KafkaConfig struct {
	Host         string        `mapstructure:"host"`
	Port         int           `mapstructure:"port"`
	Brokers      []string      `mapstructure:"brokers"`
	ReadTimeout  time.Duration `mapstructure:"read-timeout"`
	WriteTimeout time.Duration `mapstructure:"write-timeout"`
	Topic        string        `mapstructure:"topic"`
}
