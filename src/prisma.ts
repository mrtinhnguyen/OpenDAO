import { PrismaClient } from '@/prisma/client';

const omitConfig = {
  user: {
    kycCountry: true,
    kycAddress: true,
    kycDOB: true,
    kycIDNumber: true,
    kycIDType: true,
    kycName: true,
  },
};
const prismaClient = new PrismaClient({ omit: omitConfig });
declare const globalThis: { prismaGlobal: typeof prismaClient } & typeof global;
export const prisma = globalThis.prismaGlobal ?? prismaClient;
if (process.env.NODE_ENV !== 'production') globalThis.prismaGlobal = prisma;
