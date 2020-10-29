'use strict';

/**
 * Export email
 */

const path = require("path");
const nodemailer = require("nodemailer");
const configEmail = require('../config/email')

function send(message) {

  /**
   * Config nodemailer
   */
  let transporter = nodemailer.createTransport({
    host: configEmail.smpt.host,
    port: configEmail.smpt.port,
    secure: configEmail.smpt.secure,
    auth: {
      user: configEmail.smpt.user,
      pass: configEmail.smpt.pass,
    },
    debug: configEmail.options.debug,
    logger: configEmail.options.logger
  });

  /**
   * Validate param json
   */


  /**
   * Send mail with defined transport object
   */
  let optionsMail = {
    from: message.fromemailaddress,
    to: message.toemailaddress, //Can list of receivers
    cc: null,
    bcc: null,
    subject: message.subject,
    html: message.content,
    attachments: message.attachments ? message.attachments : []
  };

  transporter.sendMail(optionsMail, function (error, info) {

    var log4js = require("log4js");
    log4js.configure({
      appenders: {
        everything: { type: 'dateFile', filename: './log/logging.log', pattern: '.yyyy-MM-dd-hh', keepFileExt: true }
      },
      categories: {
        default: { appenders: ['everything'], level: 'trace' }
      }
    });

    const logger = log4js.getLogger();

    if (error) {
      console.log(error);
      logger.error(`Message :${JSON.stringify(message)}, Response: ${error}.`);
    } else {
      console.log('Email sent: ' + info.response);
      logger.info(`Message :${JSON.stringify(message)}, Response: ${JSON.stringify(info)}.`);
    }
  });
}


module.exports = {
  send,
};
