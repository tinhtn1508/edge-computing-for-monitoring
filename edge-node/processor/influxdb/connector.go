package influxdb

import (
	"context"
	"fmt"
	"time"

	influxdb "github.com/influxdata/influxdb/client/v2"
	"go.uber.org/zap"
)

// Connector is a connector interface for open, close, create the database.
type Connector interface {
	Open() error
	Close()
	CreateNewDB(string) error
	GetClient() influxdb.Client
}

// Config is used to present configured params
type Config struct {
	Host         string        `mapstructure:"host"`
	Port         int           `mapstructure:"port"`
	WriteTimeout time.Duration `mapstructure:"write-timeout"`
	BatchSize    int           `mapstructure:"batch-size"`
	BatchTime    time.Duration `mapstructure:"batch-time"`
}

// HTTPInfluxDBConnectorDeps is used to represent connector deps
type HTTPInfluxDBConnectorDeps struct {
	Log     *zap.SugaredLogger
	Ctx     context.Context
	Timeout time.Duration
	Host    string
	Port    int
}

// NewHTTPInfluxDBConnector create a new connector
func NewHTTPInfluxDBConnector(deps HTTPInfluxDBConnectorDeps) Connector {
	return &httpInfluxDBConnector{
		log:     deps.Log,
		ctx:     deps.Ctx,
		timeout: deps.Timeout,
		host:    deps.Host,
		port:    deps.Port,
	}
}

type httpInfluxDBConnector struct {
	log       *zap.SugaredLogger
	connector influxdb.Client
	ctx       context.Context
	timeout   time.Duration
	host      string
	port      int
}

func (ic *httpInfluxDBConnector) Open() error {
	if ic.connector != nil {
		return fmt.Errorf("Connection have been initialized")
	}

	conf := influxdb.HTTPConfig{
		Addr:    fmt.Sprintf("http://%s:%d", ic.host, ic.port),
		Timeout: ic.timeout,
	}

	conn, err := influxdb.NewHTTPClient(conf)
	if err != nil {
		return fmt.Errorf("Error while creating influxdb client, %w", err)
	} else {
		ic.connector = conn
	}

	if _, ver, err := ic.connector.Ping(500 * time.Millisecond); err != nil {
		return fmt.Errorf("Error while ping to influxdb client, %w", err)
	} else {
		ic.log.Infof("The connection was established successfully, ver's influxdb: %s", ver)
	}
	return nil
}

func (ic *httpInfluxDBConnector) Close() {
	if ic.connector == nil {
		fmt.Errorf("Connection have not been initialized yet")
	} else {
		ic.connector.Close()
	}
}

func (ic *httpInfluxDBConnector) CreateNewDB(DBName string) error {
	if ic.connector == nil {
		return fmt.Errorf("Connection have not been initialized yet")
	}

	q := influxdb.Query{
		Command:  fmt.Sprintf("create database %s", DBName),
		Database: DBName,
	}

	resp, err := ic.connector.Query(q)

	if err != nil {
		return fmt.Errorf("Error while creating influxdb, %w", err)
	}

	if resp.Error() != nil {
		return fmt.Errorf("Response error, %w", resp.Error())
	}

	ic.log.Infof("The %s database is created successfully", DBName)
	return nil
}

func (ic *httpInfluxDBConnector) GetClient() influxdb.Client {
	if ic.connector == nil {
		ic.log.Errorf("Connection have not been initialized yet")
		return nil
	}
	return ic.connector
}
