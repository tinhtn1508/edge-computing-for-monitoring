package core

type ICoreProcessor interface {
	Start()
	Stop()
	HandleMessage()
}

type coreProcessor struct {
}
