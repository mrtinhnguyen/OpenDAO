# Deployment Guide

This guide covers how to deploy OpenDAO while maintaining AGPL-3.0 license compliance.

> **Note**: This project is a fork of [SuperteamDAO/earn](https://github.com/SuperteamDAO/earn). Deployment instructions are based on the original project with OpenDAO-specific customizations.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Database Setup](#database-setup)
- [Deployment Options](#deployment-options)
- [License Compliance](#license-compliance)
- [Security Considerations](#security-considerations)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

### System Requirements

- Node.js 18+ 
- PostgreSQL 12+
- Redis (for caching and rate limiting)
- SSL certificate (for HTTPS)

### Required Services

- Database hosting (PostgreSQL)
- Redis hosting (optional but recommended)
- File storage (Cloudinary or similar)
- Email service (Resend or similar)
- Analytics (PostHog or similar)

## ⚙️ Environment Setup

### 1. Environment Variables

Create a `.env.production` file with the following variables:

```env
# Database
DATABASE_URL="postgresql://username:password@host:5432/database"

# NextAuth.js
NEXTAUTH_SECRET="your-production-secret"
NEXTAUTH_URL="https://yourdomain.com"

# Privy Authentication
PRIVY_APP_ID="your-privy-app-id"
PRIVY_APP_SECRET="your-privy-app-secret"

# Solana
SOLANA_RPC_URL="https://api.mainnet-beta.solana.com"
SOLANA_NETWORK="mainnet-beta"

# Email
RESEND_API_KEY="your-resend-api-key"
FROM_EMAIL="noreply@yourdomain.com"

# Redis
REDIS_URL="redis://username:password@host:6379"

# Cloudinary
CLOUDINARY_CLOUD_NAME="your-cloud-name"
CLOUDINARY_API_KEY="your-api-key"
CLOUDINARY_API_SECRET="your-api-secret"

# Analytics
POSTHOG_KEY="your-posthog-key"
POSTHOG_HOST="https://app.posthog.com"

# Security
WEBHOOK_SECRET="your-webhook-secret"

# KYC
SUMSUB_APP_TOKEN="your-sumsub-token"
SUMSUB_SECRET_KEY="your-sumsub-secret"
SUMSUB_BASE_URL="https://api.sumsub.com"

# Production
NODE_ENV="production"
NEXT_PUBLIC_APP_URL="https://yourdomain.com"
```

### 2. Security Configuration

Ensure all secrets are properly secured:

- Use strong, unique passwords
- Enable 2FA on all services
- Use environment-specific secrets
- Regularly rotate secrets

## 🗄️ Database Setup

### 1. PostgreSQL Setup

```bash
# Create database
createdb superteam_earn

# Run migrations
npx prisma migrate deploy

# Generate Prisma client
npx prisma generate
```

### 2. Database Optimization

```sql
-- Create indexes for better performance
CREATE INDEX CONCURRENTLY idx_bounties_published ON "Bounties"("isPublished", "isActive");
CREATE INDEX CONCURRENTLY idx_submissions_user ON "Submission"("userId", "createdAt");
CREATE INDEX CONCURRENTLY idx_users_email ON "User"("email");
```

### 3. Backup Strategy

```bash
# Daily backup script
#!/bin/bash
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql
```

## 🚀 Deployment Options

### Option 1: Vercel (Recommended)

1. **Connect Repository**
   ```bash
   vercel --prod
   ```

2. **Configure Environment Variables**
   - Add all production environment variables in Vercel dashboard
   - Enable automatic deployments from main branch

3. **Database Setup**
   - Use Vercel Postgres or external PostgreSQL
   - Run migrations in production

### Option 2: Docker Deployment

1. **Create Dockerfile**
   ```dockerfile
   FROM node:18-alpine
   
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci --only=production
   
   COPY . .
   RUN npm run build
   
   EXPOSE 3000
   CMD ["npm", "start"]
   ```

2. **Docker Compose**
   ```yaml
   version: '3.8'
   services:
     app:
       build: .
       ports:
         - "3000:3000"
       environment:
         - DATABASE_URL=${DATABASE_URL}
         - NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
       depends_on:
         - postgres
         - redis
     
     postgres:
       image: postgres:15
       environment:
         POSTGRES_DB: superteam_earn
         POSTGRES_USER: ${DB_USER}
         POSTGRES_PASSWORD: ${DB_PASSWORD}
       volumes:
         - postgres_data:/var/lib/postgresql/data
     
     redis:
       image: redis:7-alpine
       volumes:
         - redis_data:/data
   
   volumes:
     postgres_data:
     redis_data:
   ```

### Option 3: Traditional Server

1. **Server Setup**
   ```bash
   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Install PM2
   npm install -g pm2
   
   # Clone and setup
   git clone https://github.com/mrtinhnguyen/OpenDAO.git
   cd OpenDAO
   npm install
   npm run build
   ```

2. **PM2 Configuration**
   ```json
   {
     "apps": [{
       "name": "opendao",
       "script": "npm",
       "args": "start",
       "env": {
         "NODE_ENV": "production",
         "PORT": 3000
       }
     }]
   }
   ```

## ⚖️ License Compliance

### Required for AGPL-3.0 Compliance

1. **Source Code Availability**
   ```html
   <!-- Add to your website footer -->
   <div class="license-notice">
     <p>
       This service is powered by software licensed under the 
       <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU Affero General Public License v3.0</a>.
     </p>
     <p>
       Source code: <a href="https://github.com/mrtinhnguyen/OpenDAO">OpenDAO Repository</a>
     </p>
     <p>
       Original project: <a href="https://github.com/SuperteamDAO/earn">SuperteamDAO/earn</a>
     </p>
   </div>
   ```

2. **Source Code Repository**
   - Maintain a public repository with complete source code
   - Include all modifications and customizations
   - Keep repository up-to-date with deployed version

3. **License Documentation**
   - Include LICENSE file in repository
   - Add license notices to source files
   - Document any modifications made

### Compliance Checklist

- [ ] Source code is publicly available
- [ ] License notices are included
- [ ] Modifications are documented
- [ ] Users can access source code
- [ ] No additional restrictions added

## 🔒 Security Considerations

### 1. HTTPS Configuration

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 2. Security Headers

```javascript
// next.config.js
const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  },
  {
    key: 'X-Frame-Options',
    value: 'DENY'
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff'
  },
  {
    key: 'Referrer-Policy',
    value: 'origin-when-cross-origin'
  }
];

module.exports = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: securityHeaders,
      },
    ];
  },
};
```

### 3. Rate Limiting

```javascript
// Implement rate limiting
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});
```

## 📊 Monitoring

### 1. Application Monitoring

```javascript
// Add monitoring
import { init } from '@sentry/nextjs';

init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
});
```

### 2. Database Monitoring

```sql
-- Monitor slow queries
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;
```

### 3. Performance Monitoring

- Set up uptime monitoring
- Monitor response times
- Track error rates
- Monitor database performance

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Issues**
   ```bash
   # Check database connectivity
   npx prisma db pull
   ```

2. **Build Failures**
   ```bash
   # Clear cache and rebuild
   rm -rf .next
   npm run build
   ```

3. **Environment Variable Issues**
   ```bash
   # Verify environment variables
   node -e "console.log(process.env.DATABASE_URL)"
   ```

### Logs and Debugging

```bash
# View application logs
pm2 logs opendao

# Database logs
tail -f /var/log/postgresql/postgresql-*.log

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

## 📚 Additional Resources

- [Next.js Deployment Documentation](https://nextjs.org/docs/deployment)
- [Prisma Deployment Guide](https://www.prisma.io/docs/guides/deployment)
- [Vercel Documentation](https://vercel.com/docs)
- [Docker Documentation](https://docs.docker.com/)

---

**Important**: Always ensure AGPL-3.0 compliance when deploying. This includes making source code available and maintaining proper license notices.
