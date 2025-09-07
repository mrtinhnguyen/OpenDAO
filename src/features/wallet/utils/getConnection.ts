import { type Commitment, Connection } from '@solana/web3.js';

let connectionInstance: Connection | null = null;

// Fallback RPC endpoints
const FALLBACK_RPC_URLS = [
  'https://api.mainnet-beta.solana.com',
  'https://solana-api.projectserum.com',
  'https://rpc.ankr.com/solana',
];

export function getConnection(
  commitment: Commitment = 'confirmed',
): Connection {
  if (!connectionInstance) {
    const primaryRpcUrl = process.env.NEXT_PUBLIC_RPC_URL;

    // Use primary RPC if available, otherwise use fallback
    const rpcUrl = primaryRpcUrl
      ? `https://${primaryRpcUrl}`
      : FALLBACK_RPC_URLS[0];

    console.log('Using Solana RPC:', rpcUrl);

    connectionInstance = new Connection(rpcUrl, {
      commitment,
      confirmTransactionInitialTimeout: 60000, // 60 seconds
      disableRetryOnRateLimit: false,
    });
  }
  return connectionInstance;
}

// Function to create a new connection with fallback
export async function getConnectionWithFallback(
  commitment: Commitment = 'confirmed',
): Promise<Connection> {
  const rpcUrls = [
    process.env.NEXT_PUBLIC_RPC_URL
      ? `https://${process.env.NEXT_PUBLIC_RPC_URL}`
      : null,
    ...FALLBACK_RPC_URLS,
  ].filter(Boolean);

  for (const rpcUrl of rpcUrls) {
    try {
      const connection = new Connection(rpcUrl!, {
        commitment,
        confirmTransactionInitialTimeout: 30000, // 30 seconds
        disableRetryOnRateLimit: false,
      });

      // Test connection
      await connection.getVersion();
      console.log('Successfully connected to RPC:', rpcUrl);
      return connection;
    } catch (error) {
      console.warn(`Failed to connect to RPC ${rpcUrl}:`, error);
      continue;
    }
  }

  throw new Error('All RPC endpoints failed');
}
