# Multi-stage Dockerfile for Strapi CMS Production

# Stage 1: Dependencies
FROM node:22-alpine AS dependencies

WORKDIR /app

COPY package.json package-lock.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Stage 2: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Set NODE_ENV to production so plugins.ts expects GCP_SERVICE_ACCOUNT_JSON env var
ENV NODE_ENV=production

# Copy dependencies
COPY --from=dependencies /app/node_modules ./node_modules

# Copy source code
COPY . .

# Build the application (GCP_SERVICE_ACCOUNT_JSON can be empty/dummy during build)
RUN DATABASE_CLIENT='postgres' \
    GCP_SERVICE_ACCOUNT_JSON='{}' \
    GCS_BUCKET_NAME='dummy' \
    GCS_PROJECT_ID='dummy' \
    APP_KEYS='dummy' \
    API_TOKEN_SALT='dummy' \
    ADMIN_JWT_SECRET='dummy' \
    TRANSFER_TOKEN_SALT='dummy' \
    JWT_SECRET='dummy' \
    npm run build

# Stage 3: Production
FROM node:22-alpine AS production

WORKDIR /app

# Install dumb-init for proper signal handling in containers
RUN apk add --no-cache dumb-init

# Create a non-root user for security (BEFORE copying files)
RUN addgroup -g 1001 -S strapi && \
    adduser -S strapi -u 1001 && \
    chown strapi:strapi /app

# Set environment to production
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=8080

# Switch to strapi user
USER strapi

# Copy package files and install production dependencies only (with correct ownership)
COPY --chown=strapi:strapi package.json package-lock.json ./
RUN npm ci --only=production --ignore-scripts

# Copy built application from builder stage (with correct ownership)
COPY --chown=strapi:strapi --from=builder /app/dist ./dist
COPY --chown=strapi:strapi --from=builder /app/public ./public
COPY --chown=strapi:strapi --from=builder /app/favicon.png ./favicon.png

# Copy database migrations if they exist
COPY --chown=strapi:strapi --from=builder /app/database ./database

# Copy compiled config files to root config directory
# Strapi expects config files at /app/config/ in production
COPY --chown=strapi:strapi --from=builder /app/dist/config ./config

# Copy admin panel build to where Strapi expects it
COPY --chown=strapi:strapi --from=builder /app/dist/build ./build

# Expose port 8080 (Cloud Run default, can be overridden with PORT env var)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD node -e "require('http').get('http://localhost:8080/_health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start Strapi in production mode
CMD ["npm", "run", "start"]

# Keep container running for debugging (replace above line when debugging is done)
# CMD ["sleep", "infinity"]

