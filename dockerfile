# -----------------------------
# 1. BUILD STAGE
# -----------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./
COPY tsconfig*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Build NestJS (ts → js)
RUN npm run build


# -----------------------------
# 2. RUN STAGE
# -----------------------------
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only necessary production files
COPY package*.json ./

# Install only prod dependencies
RUN npm install --only=production

# Copy built artifacts from builder
COPY --from=builder /app/dist ./dist

# App exposes port 3000 by default
EXPOSE 3000

# Start server
CMD ["node", "dist/main.js"]
