import { createClient } from 'redis';

const redis = createClient({
  socket: {
    host: process.env.REDIS_HOST || '103.104.119.144',
    port: parseInt(process.env.REDIS_PORT || '6379'),
  },
  // Nếu Redis có password:
  password: process.env.REDIS_PASSWORD,
});

redis.on('error', (err) => console.error('Redis Client Error', err));

await redis.connect();

export { redis };
