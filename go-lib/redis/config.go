package redis

import "time"

// RedisConfig ...
type RedisConfig struct {
	Addr 	string			`mapstructure:"address"`
	TLL 	time.Duration 	`mapstructure:"tll"`
	Timeout time.Duration   `mapstructure:"timeout"`
}
