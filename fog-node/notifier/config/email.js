module.exports = {
  smpt: {
    client:  'gmail',
    host: process.env.SMTP_HOST || 'smtp.googlemail.com',
    port: process.env.SMTP_PORT || 465, // Port
    secure: process.env.SMTP_SECURE || true, // this is true as port is 465
    user: process.env.AUTH_USERNAME_GMAIL || 'test@gmail.com',
    pass: process.env.AUTH_PASSWORD_GMAIL || 'test@123', 
  },
  options: {
    debug: process.env.MAILER_DEBUG || false, // show debug output
    logger: process.env.MAILER_LOGGER || false // log information in console
  }
};
