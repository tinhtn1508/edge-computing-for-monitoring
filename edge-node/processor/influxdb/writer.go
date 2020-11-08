package influxdb

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	influxdb "github.com/influxdata/influxdb/client/v2"
	"github.com/tinhtn1508/edge-computing-for-monitor/edge-node/processor/types"
	"go.uber.org/zap"
)

// IWriter is used to public writer's methods
type IWriter interface {
	Init(client influxdb.Client) error
	Write(info WriterInfo) error
}

// WriterConfig is used to present for configure params
type WriterConfig struct {
	Log       *zap.SugaredLogger
	Ctx       context.Context
	Batchsize int
	Duration  time.Duration
	Retries   int
	DBName    string
}

type WriteData struct {
}

// WriterInfo is used to write information
type WriterInfo struct {
	Measurement string
	Tags        map[string]string
	// Time        time.Time
	// Value       float64
	Data []byte
}

type simpleWriter struct {
	log         *zap.SugaredLogger
	ctx         context.Context
	batchsize   int
	dbName      string
	duration    time.Duration
	retries     int
	writer      influxdb.Client
	point       chan *influxdb.Point
	batchPoints []*influxdb.Point
}

// NewSimpleWriter is used to create a writer
func NewSimpleWriter(cfg WriterConfig) IWriter {
	return &simpleWriter{
		log:       cfg.Log,
		ctx:       cfg.Ctx,
		batchsize: cfg.Batchsize,
		dbName:    cfg.DBName,
		duration:  cfg.Duration,
		retries:   cfg.Retries, // TODO
	}
}

func (iw *simpleWriter) Init(client influxdb.Client) error {
	iw.writer = client
	iw.point = make(chan *influxdb.Point, 3)

	go iw._batchHandler()
	return nil
}

func (iw *simpleWriter) _batchHandler() {
	timer := time.NewTicker(iw.duration)
	for {
		select {
		case p := <-iw.point:
			iw.batchPoints = append(iw.batchPoints, p)
			if len(iw.batchPoints) >= iw.batchsize {
				iw._write()
			}
		case <-timer.C:
			iw._write()
		}
	}
	timer.Stop()
}

func (iw *simpleWriter) _write() {
	if iw.writer == nil {
		iw.log.Errorf("The writer have not been initialized yet")
		return
	}

	if len(iw.batchPoints) == 0 {
		iw.log.Warn("Batch points is currently empty !!!")
		return
	}

	bps, err := influxdb.NewBatchPoints(influxdb.BatchPointsConfig{
		Database: iw.dbName,
		// RetentionPolicy: "default",
	})

	if err != nil {
		iw.log.Errorf("Error while create new batch points")
		return
	}
	bps.AddPoints(iw.batchPoints)

	if err := iw.writer.Write(bps); err != nil {
		iw.log.Errorf("Error while writing to influxdb, ", err)
		return
	}

	// Clear batchPoints after writing succeesfully
	iw.batchPoints = nil
}

func (iw *simpleWriter) Write(info WriterInfo) error {
	if iw.writer == nil {
		return fmt.Errorf("The writer have not been initialized yet")
	}

	data := &types.SensorSignal{}
	if err := json.Unmarshal(info.Data, data); err != nil {
		return fmt.Errorf("Malformed number: %s / Error: %s", info.Data, err)
	}

	if p, err := influxdb.NewPoint(info.Measurement,
		info.Tags, map[string]interface{}{
			"value": data.Value},
		time.Unix(0, int64(data.TimeStamp))); err != nil {
		return fmt.Errorf("Error while create a new point, %w", err)
	} else {
		iw.point <- p
	}
	return nil
}
