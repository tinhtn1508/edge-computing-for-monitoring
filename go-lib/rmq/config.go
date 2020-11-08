package rmq

import "fmt"

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
