package influxdb

import influxdb "github.com/influxdata/influxdb/client/v2"

// IReader is used to public writer's methods
type IReader interface {
	Init(client influxdb.Client)
	Read(key []byte, value []byte) error
}

// TODO
