FROM node:22-alpine

# The database is not a build argument: the competition environment passes DB_HOST, DB_PORT, DB_DATABASE,
# DB_USERNAME and DB_PASSWORD to the container when it starts (src/database-url.js builds DATABASE_URL from them)
ARG NPM_REGISTRY

# Configure npm registry for Verdaccio cache
RUN if [ -n "$NPM_REGISTRY" ]; then \
        npm config set registry "$NPM_REGISTRY" && \
        npm config set strict-ssl false; \
    fi

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install --loglevel error --verbose

# Copy Prisma schema
COPY prisma ./prisma/

# Generate Prisma Client
RUN npx prisma generate

# Copy application code
COPY . .

EXPOSE 80

CMD ["node", "src/server.js"]
