package cmd

import (
	"context"
	"fmt"
	"net/url"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/spf13/cobra"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/error-consumer/config"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/error-consumer/httpclient"
	"go.uber.org/zap"
)

var log *zap.SugaredLogger
var globalContext context.Context

var rootCmd = &cobra.Command{
	Use: "",
	Run: func(cmd *cobra.Command, args []string) {
		log.Infof("hello")

		// kafkaClient := kafka.NewTcpKafkaConnector(kafka.TcpKafkaConnectorDeps{
		// 	Log:     log,
		// 	Ctx:     globalContext,
		// 	Timeout: 500 * time.Millisecond,
		// 	Host:    config.GetConfig().KafkaConfig.Host,
		// })
		// if err := kafkaClient.Open(); err != nil {
		// 	log.Fatalf("error while opening kafka connection: %s", err)
		// }
		// if err := kafkaClient.CreateTopics(config.GetConfig().KafkaConfig.Topic, 1, 1); err != nil {
		// 	log.Fatalf("error while creating kafka topic: %s", err)
		// }

		// kafkaConsumer := kafka.NewGeneralConsumer(kafka.GeneralConsumerDeps{
		// 	Log:       log,
		// 	Ctx:       globalContext,
		// 	Topic:     config.GetConfig().KafkaConfig.Topic,
		// 	Brokers:   config.GetConfig().KafkaConfig.Brokers,
		// 	Partition: config.GetConfig().KafkaConfig.Partition,
		// 	Offset:    -1,
		// 	// Consume:   processor.HandleMessage,
		// })

		// if err := kafkaConsumer.Init(); err != nil {
		// 	log.Fatalf("error while initializing kafka consumer")
		// }

		// if err := kafkaConsumer.StartConsuming(); err != nil {
		// 	log.Fatalf("error while start consuming kafka messages")
		// }

		httpClient := httpclient.NewHttpClient(
			"http://lum-staging.knorex.com/ws/1.4/geo/getIpLocation",
			500*time.Millisecond,
			func(code int, body []byte) bool {
				log.Infof("code: %d", code)
				log.Infof("body: %s", body)
				return true
			},
		)

		for {
			time.Sleep(1 * time.Second)
			// http://lum-staging.knorex.com/ws/1.4/geo/getIpLocation?apikey=NBfbjSPgRDIfoLhYmGYwYxXMmOxqxO&query=39.109.187.214
			values := &url.Values{}
			values.Add("apikey", "NBfbjSPgRDIfoLhYmGYwYxXMmOxqxO")
			values.Add("query", "39.109.187.214")
			httpClient.DoGetJson(values)
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
