package gokafka

// KafkaConfig is used to config for Kafka connection instances
type KafkaConfig struct {
	Host          string   `mapstructure:"host"`
	Port          int      `mapstructure:"port"`
	Brokers       []string `mapstructure:"brokers"`
	DialerTimeout int      `mapstructure:"dialer-timeout"`
	WriteTimeout  int      `mapstructure:"write-timeout"`
	ReadTimeout   int      `mapstructure:"read-timeout"`
}
