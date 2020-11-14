package config

import (
	"fmt"
	"log"
	"strings"

	"github.com/spf13/viper"
	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/core"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/influxdb"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/kafka"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/rmq"
)

// Config holds all the configurations of the tool
type Config struct {
	KafkaMgtConfig kafka.KafkaConfig  `mapstructure:"kafka_management"`
	KafkaErrConfig kafka.KafkaConfig  `mapstructure:"kafka_error"`
	RMQConfig      rmq.RabbitMQConfig `mapstructure:"rabbitmq"`
	CoreConfig     core.CoreConfig    `mapstructure:"core"`
	InfluxDBConfig influxdb.Config    `mapstructure:"influxdb"`
	EdgeNodeName   string             `mapstructure:"edge_node_name"`
}

// GetKafkaHost produces kafka hostname
func (cfg *Config) GetKafkaMgtHost() string {
	return fmt.Sprintf("%s:%d", cfg.KafkaMgtConfig.Host, cfg.KafkaMgtConfig.Port)
}

var values Config

func init() {
	config := viper.New()
	config.SetConfigName("config")
	config.AddConfigPath("./config/")
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
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
