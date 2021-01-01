package slackclient

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/slack-go/slack"
)

var slackClient *SlackClient

// SlackClient class
type SlackClient struct {
	client *slack.Client
}

// SlackClientInit method
func (sc *SlackClient) SlackClientInit(token string) {
	if token == "" {
		log.Fatalln("Slacl Token not found")
	}

	log.Println("Slack Client Initializing ... ")
	sc.client = slack.New(token)
}

//SendMessageToChanel method
func (sc *SlackClient) SendMessageToChanel(channel string, message string) {
	if channel == "" || message == "" {
		log.Fatalf("Channel or message not found")
	}

	channelID, timestamp, err := sc.client.PostMessage(
		channel,
		slack.MsgOptionText(message, false),
		slack.MsgOptionAsUser(true),
	)
	if err != nil {
		log.Fatalf("ERROR: %s\n", err)
	}

	log.Printf("Message successfully sent to channel %s at %s", channelID, timestamp)
}

// init module function
func init() {
	err := godotenv.Load("./slack.env")
	if err != nil {
		log.Fatal("Error loading slack.env file")
	}

	slackToken := os.Getenv("SLACK_TOKEN")

	slackClient = &SlackClient{}
	slackClient.SlackClientInit(slackToken)
}

// func main() {
// 	err := godotenv.Load("./slack.env")
// 	if err != nil {
// 		log.Fatal("Error loading slack.env file")
// 	}

// 	slackToken := os.Getenv("SLACK_TOKEN")
// 	log.Printf("slackToken: %s", slackToken)

// 	sc := SlackClient{}
// 	sc.SlackClientInit("xoxb-1607306712658-1607332830498-OCWytVekQjUHk80m7EUuzwe3")
// 	// sc.SendMessageToChanel("#testpython", "Hello @gamil.com")

// 	for i := 10; i <= 1; i-- {
// 		sc.SendMessageToChanel("#testpython", "Hello @gamil.com")
// 		time.Sleep(2)
// 	}
// }
