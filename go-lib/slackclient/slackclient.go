package slackclient

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/slack-go/slack"
	"go.uber.org/zap"
)

// ISlackClient ...
type ISlackClient interface {
	Send(string, string, string) error
}

// SlackClientConf ...
type SlackClientConf struct {
	Token   string
	Log     *zap.SugaredLogger
	Ctx     context.Context
	Timeout time.Duration
}

type slackclient struct {
	client  *slack.Client
	log     *zap.SugaredLogger
	ctx     context.Context
	timeout time.Duration
}

// NewSlackClient ...
func NewSlackClient(conf SlackClientConf) ISlackClient {
	return &slackclient{
		log:     conf.Log,
		client:  slack.New(conf.Token),
		ctx:     conf.Ctx,
		timeout: conf.Timeout,
	}
}

func (sc *slackclient) Send(channel string, message string, email string) error {
	if channel == "" || message == "" || email == "" {
		return fmt.Errorf("Channel or message or email not found")
	}

	timeoutCtx, cancel := context.WithTimeout(sc.ctx, sc.timeout)
	defer cancel()

	user, _err := sc.client.GetUserByEmailContext(timeoutCtx, email)
	tag := fmt.Sprintf("<@%s>", user.ID)
	if _err == nil {
		message = fmt.Sprintf(message, tag)
	} else {
		message = fmt.Sprintf(message, strings.Split(email, "@")[0])
	}

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
