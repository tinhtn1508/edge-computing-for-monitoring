package httpclient

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"time"
)

type HttpReturnFunc func(statusCode int, body []byte) bool

type IHttpClient interface {
	DoGetJson() error
	DoPostJson(*url.Values, interface{}) error
}

type httpClient struct {
	url        string
	timeout    time.Duration
	client     *http.Client
	returnFunc HttpReturnFunc
}

func NewHttpClient(url string, timeout time.Duration, returnFn HttpReturnFunc) IHttpClient {
	return &httpClient{
		url: url,
		client: &http.Client{
			Timeout: timeout,
		},
		returnFunc: returnFn,
	}
}

func (c *httpClient) do(req *http.Request) error {
	if req == nil {
		return fmt.Errorf("input nil req")
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}
	code := resp.StatusCode
	if c.returnFunc != nil {
		if !c.returnFunc(code, body) {
			return fmt.Errorf("return function failed")
		}
	}
	return nil
}

func (c *httpClient) getUrl(values *url.Values) string {
	if values == nil {
		return c.url
	}

	return c.url + values.Encode()
}

func (c *httpClient) DoGetJson(values *url.Values) error {
	url := c.getUrl(values)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")

	return c.do(req)
}

func (c *httpClient) DoPostJson(values *url.Values, data interface{}) error {
	if data == nil {
		return fmt.Errorf("input nil body")
	}

	jsonbody, err := json.Marshal(data)
	if err != nil {
		return err
	}

	url := c.getUrl(values)
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonbody))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")

	return c.do(req)
}
