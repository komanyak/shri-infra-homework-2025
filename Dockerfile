FROM node:18-alpine AS client-builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app

COPY --from=client-builder /app/dist ./dist
COPY --from=client-builder /app/src/server ./src/server
COPY --from=client-builder /app/package*.json ./

RUN npm ci --omit=dev

ENV PORT=3000
EXPOSE 3000

CMD ["node", "src/server/index.js"]