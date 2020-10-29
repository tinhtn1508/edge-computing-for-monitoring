'use strict';

/**
 * Export connector redis
 */
var redis = require("redis");

module.exports = {
  subscriber: (channelName) => {
    var subscriber = redis.createClient();

    subscriber.on("message", function (channel, message) {
      console.log("Message: " + message + " on channel: " + channel + " is arrive!");
    });

    subscriber.subscribe(channelName);
  }
};