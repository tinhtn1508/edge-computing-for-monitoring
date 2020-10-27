package gormq

// RabbitMQConfig is used to config for RMQ instances
type RabbitMQConfig struct {
	Host string `mapstructure:"host"`
	Port int    `mapstructure:"port"`
}
