"use strict";

require('dotenv').config()

const mail = require('./email');
var redis = require("redis");

console.log(process.env)

var subscriber = redis.createClient({
  host: 'redis-server',
  port: 6379
});

subscriber.on("message", function (channel, message) {
  const messageJson = JSON.parse(message)

  /**
   * Email
   */
  mail.send(messageJson);
});

subscriber.subscribe("notification");

