package cmd

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/labstack/echo"
	"github.com/spf13/cobra"
	"go.uber.org/zap"

	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/config"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/handler"
	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/psqlclient"
)

var log *zap.SugaredLogger
var globalContext context.Context

var rootCmd = &cobra.Command{
	Use: "",
	Run: func(cmd *cobra.Command, args []string) {
		sqlClient := psqlclient.NewPsqlClient(psqlclient.PsqlDeps{
			Log:    log,
			Ctx:    globalContext,
			Config: config.GetConfig().PsqlConfig,
		})

		if err := sqlClient.Start(); err != nil {
			log.Fatalf("Failed to init DB: %s", err)
		}

		apiHandler := handler.NewHandler(handler.HandlerDeps{
			Log:     log,
			DBCheck: sqlClient.Isok,
		})

		e := echo.New()

		g := e.Group("/api/v1")
		g.GET("/health", apiHandler.HealthCheck)
		// g.GET("/contact")

		e.Start(fmt.Sprintf(":%d", config.GetConfig().ServerConfig.Port))
		log.Fatal("It should not come here!")
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
