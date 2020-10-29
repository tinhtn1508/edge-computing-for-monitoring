module.exports = {
  connector: 'redis',
  settings: {
    client: 'redis',
    host: process.env.DATABASE_HOST || '127.0.0.1',
    port: process.env.DATABASE_PORT || 6379,
    db: process.env.DATABASE_NAME || 'none',
    username: process.env.DATABASE_USERNAME || 'no_name',
    password: process.env.DATABASE_PASSWORD || 'no_password',
    ssl: process.env.DATABASE_SSL || false,
  },
  options: {}
};
