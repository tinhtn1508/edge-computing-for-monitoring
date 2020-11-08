module.exports = ({ env }) => ({
  defaultConnection: 'default',
  connections: {
    default: {
      connector: 'bookshelf',
      settings: {
        client: 'postgres',
        host: env('DATABASE_HOST', '0.0.0.0'),
        port: env.int('DATABASE_PORT', 5432),
        database: env('DATABASE_NAME', 'catalog'),
        username: env('DATABASE_USERNAME', 'catalog'),
        password: env('DATABASE_PASSWORD', 'catalog'),
        ssl: env.bool('DATABASE_SSL', false),
      },
      options: {
      }
    },
  },
});
