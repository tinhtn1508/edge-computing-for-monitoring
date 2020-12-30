package handler

import (
	"net/http"

	"github.com/labstack/echo"
	"go.uber.org/zap"

	"github.com/tinhtn1508/edge-computing-for-monitor/fog-node/go-catalog/types"
)

type DBCheckFunc func() bool
type DBGetContactFunc func(string, string) types.GetContactResponse

type HandlerDeps struct {
	Log          *zap.SugaredLogger
	DBCheck      DBCheckFunc
	DBGetContact DBGetContactFunc
}

func NewHandler(deps HandlerDeps) IHandler {
	return &handler{
		log:          deps.Log,
		dbCheck:      deps.DBCheck,
		dbGetContact: deps.DBGetContact,
	}
}

type IHandler interface {
	HealthCheck(ctx echo.Context) error
	GetContact(ctx echo.Context) error
}

type handler struct {
	log          *zap.SugaredLogger
	dbCheck      DBCheckFunc
	dbGetContact DBGetContactFunc
}

func (h *handler) HealthCheck(ctx echo.Context) error {
	result := true
	if h.dbCheck != nil {
		result = h.dbCheck()
	}
	if result {
		return ctx.String(http.StatusOK, "OK")
	}
	return ctx.String(http.StatusInternalServerError, "Server Error")
}

func (h *handler) GetContact(ctx echo.Context) error {
	req := new(types.GetContactRequest)
	if err := ctx.Bind(req); err != nil {
		ctx.String(http.StatusBadRequest, "Bad Request")
		return err
	}
	resp := h.dbGetContact(req.Sensor, req.EdgeNode)
	ctx.JSON(http.StatusOK, resp)
	return nil
}
