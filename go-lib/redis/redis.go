package redis

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/go-redis/redis"
	"go.uber.org/zap"
)

type RedisGetPostProcessingFunction func(key string, returnedString string) error

// RedisClient ...
type RedisClient interface {
	Start() error
	Stop()
	SetKeyString(key string, value string) error
	GetKeyString(ctx context.Context, key string, postProcessing RedisGetPostProcessingFunction) (string, error)
}

// RedisClientDeps ...
type RedisClientDeps struct {
	Log     *zap.SugaredLogger
	Addr    string
	Ctx     context.Context
	TLL		time.Duration
	Timeout	time.Duration
}

type redisClient struct {
	sync.RWMutex
	log         *zap.SugaredLogger
	client      *redis.Client
	alive       bool
	stopChannel chan bool
	tll			time.Duration
	timeout		time.Duration
	ctx         context.Context
}

// NewRedisConnector ...
func NewRedisConnector(deps RedisClientDeps) RedisClient {
	instance := redisClient{}
	instance.client 	 = redis.NewClient(&redis.Options{Addr: deps.Addr,})
	instance.log 		 = deps.Log
	instance.stopChannel = make(chan bool)
	instance.alive 		 = false
	instance.tll 		 = deps.TLL
	instance.timeout 	 = deps.Timeout
	return &instance
}

func (r *redisClient) Start() error {
	healthcheck := func() {
		ticker := time.NewTicker(5 * time.Second)
		for {
			select {
			case <-r.stopChannel:
				return
			case <-ticker.C:
				_, err := r.client.Ping().Result()
				r.Lock()
				r.alive = (err == nil)
				r.Unlock()
			}
		}
	}
	go healthcheck()
	return nil
}

func (r *redisClient) Stop() {
	r.stopChannel <- true
}

func (r *redisClient) checkClient() bool {
	r.RLock()
	defer r.RUnlock()
	return r.alive
}

func (r *redisClient) getTimeoutClient() (*redis.Client, func()) {
	timeoutCtx, cancel := context.WithTimeout(r.ctx, r.timeout)
	timeoutClient := r.client.WithContext(timeoutCtx)
	return timeoutClient, cancel
}

func (r *redisClient) SetKeyString(key string, value string) error {
	if !r.checkClient() {
		return fmt.Errorf("error while connecting to redis")
	}
	timeoutClient, cancel := r.getTimeoutClient()
	defer cancel()
	var err error
	if r.tll > 0 {
		_, err = timeoutClient.Set(key, value, r.tll.Milliseconds()).Result()
	} else {
		_, err = timeoutClient.Set(key, value, 0).Result()
	}
	return err
}

func (r *redisClient) GetKeyString(ctx context.Context, key string, postProcessing RedisGetPostProcessingFunction) (string, error) {
	if !r.checkClient() {
		return "", fmt.Errorf("error while connecting to redis")
	}
	timeoutClient, cancel := r.getTimeoutClient()
	defer cancel()
	val, err := timeoutClient.Get(key).Result()
	if err != nil {
		return "", fmt.Errorf("error get key string %s / %w", key, err)
	}
	if postProcessing != nil {
		return val, postProcessing(key, val)
	}
	return val, nil
}

