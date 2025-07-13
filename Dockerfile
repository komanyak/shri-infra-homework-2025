FROM node:18-alpine AS builder
WORKDIR /app

# Установка зависимостей
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Копирование исходного кода
COPY . .

# Сборка клиентской части
RUN npm run build

# Компиляция серверного кода с правильными настройками
RUN npx tsc --project tsconfig.json --module commonjs --skipLibCheck

FROM node:18-alpine
WORKDIR /app

# Копируем только необходимые файлы
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src/server ./src/server
COPY --from=builder /app/package*.json ./

# Установка production зависимостей
RUN npm ci --omit=dev

ENV PORT=3000
EXPOSE 3000

CMD ["node", "src/server/index.js"]