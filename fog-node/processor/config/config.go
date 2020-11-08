package config

import (
	"fmt"
	"log"

	"github.com/spf13/viper"
	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/influxdb"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/processor/core"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/processor/kafka"
)

// Config holds all the configurations of the tool
type Config struct {
	KafkaConfig    kafka.KafkaConfig `mapstructure:"kafka"`
	CoreConfig     core.CoreConfig   `mapstructure:"core"`
	InfluxDBConfig influxdb.Config   `mapstructure:"influxdb"`
}

// GetKafkaHost produces kafka hostname
func (cfg *Config) GetKafkaHost() string {
	return fmt.Sprintf("%s:%d", cfg.KafkaConfig.Host, cfg.KafkaConfig.Port)
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
