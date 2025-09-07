import { type NextApiRequest, type NextApiResponse } from 'next';

import logger from '@/lib/logger';
import { checkAndApplyRateLimitApp } from '@/lib/rateLimiterService';
import { uploadSignatureRateLimiter } from '@/lib/ratelimit';

interface IpApiResponse {
  ip: string;
  city: string;
  region: string;
  country: string;
  country_code: string;
  timezone: string;
  utc_offset: string;
  country_calling_code: string;
  currency: string;
  languages: string;
  asn: string;
  org: string;
}

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Get client IP for rate limiting
    const clientIp =
      req.headers['x-forwarded-for'] ||
      req.connection.remoteAddress ||
      'unknown';

    // Apply rate limiting
    const rateLimitResponse = await checkAndApplyRateLimitApp({
      limiter: uploadSignatureRateLimiter, // Reuse existing limiter
      identifier: clientIp as string,
      routeName: 'geolocation',
    });

    if (rateLimitResponse) {
      logger.warn('Rate limit exceeded for geolocation request', { clientIp });
      return rateLimitResponse;
    }

    const response = await fetch('https://ipapi.co/json/', {
      method: 'GET',
      headers: {
        'User-Agent': 'Superteam-Earn/1.0',
        Accept: 'application/json',
      },
      // Add timeout to prevent hanging requests
      signal: AbortSignal.timeout(5000), // 5 second timeout
    });

    if (!response.ok) {
      logger.warn(`ipapi.co returned status: ${response.status}`);
      return res.status(response.status).json({
        error: 'Failed to fetch location data',
        status: response.status,
      });
    }

    const data: IpApiResponse = await response.json();

    logger.debug('Successfully fetched location data', {
      country: data.country_code,
      city: data.city,
    });

    // Return only the data we need
    return res.status(200).json({
      country_code: data.country_code,
      country: data.country,
      city: data.city,
      region: data.region,
      timezone: data.timezone,
    });
  } catch (error: any) {
    logger.error('Error fetching location data:', error);

    if (error.name === 'AbortError') {
      return res.status(408).json({
        error: 'Request timeout',
        message: 'Location service is temporarily unavailable',
      });
    }

    return res.status(500).json({
      error: 'Internal server error',
      message: 'Failed to fetch location data',
    });
  }
}
