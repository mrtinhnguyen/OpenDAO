import { PrismaClient } from '@prisma/client';

declare global {
  let prismaGlobal: PrismaClient | undefined;
}

// Tạo PrismaClient singleton, tránh tạo nhiều instance trong dev mode
export const prisma =
  globalThis.prismaGlobal ??
  new PrismaClient({
    log: ['query', 'error'], // giúp debug
  });

if (process.env.NODE_ENV !== 'production') globalThis.prismaGlobal = prisma;
