package slackclient

import (
	"context"
	"fmt"
	"time"

	"github.com/slack-go/slack"
	"go.uber.org/zap"
)

// ISlackClient ...
type ISlackClient interface {
	Send(string, string) error
}

// SlackClientConf ...
type SlackClientConf struct {
	Token   string
	Log     *zap.SugaredLogger
	Ctx     context.Context
	Timeout time.Duration
}

type slacklient struct {
	client  *slack.Client
	log     *zap.SugaredLogger
	ctx     context.Context
	timeout time.Duration
}

// NewSlackClient ...
func NewSlackClient(conf SlackClientConf) ISlackClient {
	return &slacklient{
		log:     conf.Log,
		client:  slack.New(conf.Token),
		ctx:     conf.Ctx,
		timeout: time.Duration,
	}
}

func (sc *slackclient) Send(channel string, message string) error {
	if channel == "" || message == "" {
		return fmt.Errorf("Channel or message not found")
	}

	timeoutCtx, cancel := context.WithTimeout(sc.ctx, sc.timeout)
	defer cancel()

	channelID, timestamp, err := sc.client.PostMessageContext(
		timeoutCtx,
		channel,
		slack.MsgOptionText(message, false),
		slack.MsgOptionAsUser(true),
	)
	if err != nil {
		return fmt.Errorf("Error while sending message: %s", err)
	}
	sc.log.Infof("Message successfully sent to channel %s at %s", channelID, timestamp)
	return nil
}
