# syntax=docker.io/docker/dockerfile:1

FROM node:22-alpine AS base

# Step 1. Rebuild the source code only when needed
FROM base AS builder

WORKDIR /app

COPY ./server ./
RUN npm ci --silent --production

# Step 2. Production image, copy all the files and run next
FROM base AS runner

WORKDIR /app

# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 server
USER server

COPY --from=builder --chown=server:nodejs /app ./

CMD ["node", "index.js"]
