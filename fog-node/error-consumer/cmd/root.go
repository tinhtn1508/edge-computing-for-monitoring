package cmd

import (
	"context"

	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/spf13/cobra"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/error-consumer/config"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/error-consumer/core"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/kafka"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/redis"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/slackclient"
	"go.uber.org/zap"
)

var log *zap.SugaredLogger
var globalContext context.Context

var rootCmd = &cobra.Command{
	Use: "",
	Run: func(cmd *cobra.Command, args []string) {
		log.Infof("hello")

		redisClient := redis.NewRedisConnector(redis.RedisClientDeps{
			Log:	 log,
			Ctx:	 globalContext,
			Addr:	 config.GetConfig().RedisConfig.Addr,
			TLL:	 config.GetConfig().RedisConfig.TLL,
			Timeout: config.GetConfig().RedisConfig.Timeout,
		})

		if err := redisClient.Start(); err != nil {
			log.Fatalf("error while starting redis client")
		}

		slackBot := slackclient.NewSlackClient(slackclient.SlackClientConf{
			Log: 	 log,
			Ctx:	 globalContext,
			Token:	 config.GetConfig().SlackBotConfig.Token,
			Timeout: config.GetConfig().SlackBotConfig.Timeout,
		})

		errConsumerCore := core.NewCoreErrorConsumer(core.CoreErrorConsumerConf{
			Log:			log,
			RedisSetFunc: 	redisClient.SetKeyString,
			RedisGetFunc:	redisClient.GetKeyString,
			ContactURL: 	config.GetConfig().CatalogConfig.URL,
			ContactTimeout: config.GetConfig().CatalogConfig.Timeout,
			SlackSendFunc:  slackBot.Send,
			SlackChannel:	config.GetConfig().SlackBotConfig.Channel,
		})
		errConsumerCore.Start()

		kafkaClient := kafka.NewTcpKafkaConnector(kafka.TcpKafkaConnectorDeps{
			Log:     log,
			Ctx:     globalContext,
			Timeout: 500 * time.Millisecond,
			Host:    config.GetConfig().KafkaConfig.Host,
		})
		if err := kafkaClient.Open(); err != nil {
			log.Fatalf("error while opening kafka connection: %s", err)
		}
		if err := kafkaClient.CreateTopics(config.GetConfig().KafkaConfig.Topic, 1, 1); err != nil {
			log.Fatalf("error while creating kafka topic: %s", err)
		}

		kafkaConsumer := kafka.NewGeneralConsumer(kafka.GeneralConsumerDeps{
			Log:       log,
			Ctx:       globalContext,
			Topic:     config.GetConfig().KafkaConfig.Topic,
			Brokers:   config.GetConfig().KafkaConfig.Brokers,
			Partition: config.GetConfig().KafkaConfig.Partition,
			Offset:    -1,
			Consume:   errConsumerCore.HandleMessage,
		})

		if err := kafkaConsumer.Init(); err != nil {
			log.Fatalf("error while initializing kafka consumer")
		}

		if err := kafkaConsumer.StartConsuming(); err != nil {
			log.Fatalf("error while start consuming kafka messages")
		}

		for {
			time.Sleep(1 * time.Second)
		}
	},
}

func init() {
	prepareLogger()
	log.Infof("Run program with the config: %+v", *config.GetConfig())

	signals := make(chan os.Signal, 1)
	signal.Notify(signals, syscall.SIGINT, syscall.SIGKILL, syscall.SIGTERM)

	ctx, cancel := context.WithCancel(context.Background())
	go func() {
		sig := <-signals
		fmt.Println("Got signal: ", sig)
		cancel()
		os.Exit(0)
	}()

	globalContext = ctx
}

// Execute starts the tool up
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		log.Errorf("%s", err)
		os.Exit(1)
	}
}

func prepareLogger() {
	logger, _ := zap.NewDevelopment()
	log = logger.Sugar()
	log.Info("Log is prepared in development mode")
}
