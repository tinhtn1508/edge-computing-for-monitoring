package types

type SensorSignal struct {
	TimeStamp uint64  `json:"timeStamp"`
	Value     float64 `json:"value"`
}

type KeyValuePair struct {
	key   []byte
	value []byte
}

type SensorSignalTable map[string]*SensorSignal
