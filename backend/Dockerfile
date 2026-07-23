FROM node:24-alpine

RUN apk add --no-cache wget

WORKDIR /app

# Install deps first for better caching
COPY package.json package-lock.json ./
RUN npm ci

# Prisma schema for generate/migrate
COPY prisma ./prisma
RUN npx prisma generate

# Copy rest of source
COPY . .

EXPOSE 3000

CMD ["npm","run","start:dev"]
