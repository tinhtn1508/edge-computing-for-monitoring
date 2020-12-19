package types

import "time"

type SensorSignal struct {
	TimeStamp uint64  `json:"timeStamp"`
	Value     float64 `json:"value"`
}

type KeyValuePair struct {
	Key   []byte
	Value []byte
}

type SensorSignalTable map[string]*SensorSignal

type ErrorReport struct {
	EdgeNode  string    `json:"edgenode"`
	Sensor    string    `json:"sensor"`
	Time      time.Time `json:"time"`
	Describes string    `json:"describes"`
}

type SensorErrorReportTable map[string]*ErrorReport
