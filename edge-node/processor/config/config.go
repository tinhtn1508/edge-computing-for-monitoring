package config

import (
	"fmt"
	"log"

	"github.com/spf13/viper"
)

// Config holds all the configurations of the tool
type Config struct {
	Kafka struct {
		Host          string   `mapstructure:"host"`
		Port          int      `mapstructure:"port"`
		Brokers       []string `mapstructure:"brokers"`
		DialerTimeout int      `mapstructure:"dialer-timeout"`
		WriteTimeout  int      `mapstructure:"write-timeout"`
		ReadTimeout   int      `mapstructure:"read-timeout"`
	} `mapstructure:"kafka"`
}

// GetKafkaHost produces kafka hostname
func (cfg *Config) GetKafkaHost() string {
	return fmt.Sprintf("%s:%d", cfg.Kafka.Host, cfg.Kafka.Port)
}

var values Config

func init() {
	config := viper.New()
	config.SetConfigName("config")
	config.AddConfigPath("./config/")
	config.AutomaticEnv()

	if err := config.ReadInConfig(); err != nil {
		log.Fatalf("Error while reading config: %s", err)
	}

	if err := config.Unmarshal(&values); err != nil {
		log.Fatalf("Error while parsing config: %s", err)
	}
}

// GetConfig returns config instance
func GetConfig() *Config {
	return &values
}
