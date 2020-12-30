package psqlprocessor

import (
	"context"

	"database/sql"

	"go.uber.org/zap"

	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/types"
	"github.com/tinhtn1508/edge-computing-for-monitor/go-lib/psqlclient"
)

type IPsqlProcessor interface {
	CheckDB() bool
	GetWorkers(sensor string, factory string) types.GetContactResponse
}

type PsqlProcessorDeps struct {
	Log    *zap.SugaredLogger
	Ctx    context.Context
	Config psqlclient.PsqlConfig
}

type psqlProcessor struct {
	log    *zap.SugaredLogger
	ctx    context.Context
	client psqlclient.IPsqlClient
}

func NewPsqlProcessor(deps PsqlProcessorDeps) IPsqlProcessor {
	client := psqlclient.NewPsqlClient(psqlclient.PsqlDeps{
		Log:    deps.Log,
		Ctx:    deps.Ctx,
		Config: deps.Config,
	})
	instance := &psqlProcessor{
		log:    deps.Log,
		ctx:    deps.Ctx,
		client: client,
	}
	return instance
}

func (p *psqlProcessor) CheckDB() bool {
	return p.client.Isok()
}

func (p *psqlProcessor) GetWorkers(sensor string, factory string) types.GetContactResponse {
	resp := make(types.GetContactResponse, 0)
	p.client.QueryRows(func(rows *sql.Rows) bool {
		tmp := types.Contact{}
		err := rows.Scan(&tmp.ID, &tmp.Name, &tmp.Phone, &tmp.Email, &tmp.GroupName, &tmp.FactoryAddress)
		if err != nil {
			p.log.Errorf("Error while reading psql row: %s", err)
			return false
		}
		resp = append(resp, tmp)
		return true
	}, `select * from getWorkers($1, $2);`, sensor, factory)
	return resp
}
