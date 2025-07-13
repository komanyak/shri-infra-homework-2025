FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

RUN npm run build
RUN npx tsc

FROM node:18-alpine
WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/build ./build  # Скомпилированный серверный код

RUN npm ci --omit=dev

ENV PORT=3000
EXPOSE 3000

CMD ["node", "build/src/server/index.js"]