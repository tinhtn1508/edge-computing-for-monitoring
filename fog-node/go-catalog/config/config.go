package config

import (
	"log"

	"github.com/spf13/viper"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/psqlclient"
)

// Config holds all the configurations of the tool
type Config struct {
	PsqlConfig   psqlclient.PsqlConfig `mapstructure:"psql"`
	ServerConfig struct {
		Port int `mapstructure:"port"`
	} `mapstructure:"server"`
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
