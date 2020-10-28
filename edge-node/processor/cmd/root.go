package cmd

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/spf13/cobra"
	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/config"
	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/core"
	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/rmq"
	"go.uber.org/zap"
)

var log *zap.SugaredLogger
var globalContext context.Context

var rootCmd = &cobra.Command{
	Use: "",
	Run: func(cmd *cobra.Command, args []string) {
		log.Infof("hello")
		processor := core.NewCoreProcessor(core.CoreProcessorConfig{
			log,
			config.GetConfig().CoreConfig,
		})
		for _, q := range config.GetConfig().RMQConfig.Queues {
			processor.AddConsumingTask(q)
		}
		consumer, err := rmq.NewTopicConsumer(rmq.RabbitMQConsumerConfig{
			Log:              log,
			ServerURL:        config.GetConfig().RMQConfig.GetUrl(),
			Exchange:         config.GetConfig().RMQConfig.Exchange,
			QueuesProcessors: processor.GetHandlerMap(),
		})

		if err != nil {
			log.Fatalf("Error while creating consumer: %s", err)
		}
		consumer.Start()
		defer consumer.Stop()
		processor.Start()
		defer processor.Stop()
		time.Sleep(60 * time.Second)
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
