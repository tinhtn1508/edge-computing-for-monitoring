package psqlclient

import (
	"context"
	"fmt"
	"time"

	"database/sql"

	_ "github.com/lib/pq"
	"go.uber.org/zap"
)

type RowHandlingFunc func(*sql.Rows) bool

type PsqlConfig struct {
	Host                string        `mapstructure:"host"`
	Port                int           `mapstructure:"port"`
	Username            string        `mapstructure:"username"`
	Password            string        `mapstructure:"password"`
	DBname              string        `mapstructure:"dbname"`
	QueryTimeout        time.Duration `mapstructure:"querytimeout"`
	HealthcheckInterval time.Duration `mapstructure:"healthcheck_interval"`
}

func (pc *PsqlConfig) GetInfo() string {
	return fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		pc.Host, pc.Port, pc.Username, pc.Password, pc.DBname,
	)
}

type PsqlDeps struct {
	Log    *zap.SugaredLogger
	Ctx    context.Context
	Config PsqlConfig
}

type IPsqlClient interface {
	Start()
	Stop()
	Isok() bool
	DBExec(string, ...interface{}) error
	QueryRows(RowHandlingFunc, string, ...interface{}) error
}

type psqlClient struct {
	log                 *zap.SugaredLogger
	ctx                 context.Context
	host                string
	port                int
	username            string
	password            string
	dbname              string
	querytimeout        time.Duration
	healthcheckInterval time.Duration
	iamok               bool
	client              *sql.DB
	stopChannel         chan bool
}

func NewPsqlClient(deps PsqlDeps) IPsqlClient {
	dbInfo := deps.Config.GetInfo()
	db, err := sql.Open("postgres", dbInfo)
	if err != nil {
		deps.Log.Fatalf("cannot connect to psql: %s", dbInfo)
	}

	timeoutCtx, cancel := context.WithTimeout(deps.Ctx, deps.Config.QueryTimeout)
	defer cancel()

	if err := db.PingContext(timeoutCtx); err != nil {
		deps.Log.Fatalf("failed to ping psql db: %s", dbInfo)
	}

	return &psqlClient{
		log:                 deps.Log,
		ctx:                 deps.Ctx,
		host:                deps.Config.Host,
		port:                deps.Config.Port,
		username:            deps.Config.Username,
		password:            deps.Config.Password,
		dbname:              deps.Config.DBname,
		querytimeout:        deps.Config.QueryTimeout,
		healthcheckInterval: deps.Config.HealthcheckInterval,
		client:              db,
		iamok:               true,
		stopChannel:         make(chan bool),
	}
}

func (pc *psqlClient) startHealthcheck() {
	go func() {
		ticker := time.NewTicker(1 * time.Second)
		for {
			select {
			case <-pc.stopChannel:
				return
			case <-ticker.C:
				timeoutCtx, cancel := context.WithTimeout(pc.ctx, pc.querytimeout)
				pc.iamok = pc.client.PingContext(timeoutCtx) == nil
				cancel()
			}
		}
	}()
}

func (pc *psqlClient) Start() {
	pc.startHealthcheck()
}

func (pc *psqlClient) Stop() {
	pc.stopChannel <- true
}

func (pc *psqlClient) Isok() bool {
	return pc.iamok
}

func (pc *psqlClient) DBExec(cmd string, args ...interface{}) error {
	if !pc.Isok() {
		return fmt.Errorf("cannot connect to psql database")
	}

	timeoutCtx, cancel := context.WithTimeout(pc.ctx, pc.querytimeout)
	defer cancel()

	_, err := pc.client.ExecContext(timeoutCtx, cmd, args)
	return err
}

func (pc *psqlClient) QueryRows(processfn RowHandlingFunc, cmd string, args ...interface{}) error {
	if !pc.Isok() {
		return fmt.Errorf("cannot connect to psql database")
	}

	timeoutCtx, cancel := context.WithTimeout(pc.ctx, pc.querytimeout)
	defer cancel()

	rows, err := pc.client.QueryContext(timeoutCtx, cmd, args)
	defer rows.Close()
	if err != nil {
		return err
	}

	for rows.Next() {
		if !processfn(rows) {
			return fmt.Errorf("Error while processing rows")
		}
	}

	return nil
}
