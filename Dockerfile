FROM node:22-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    chromium \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN npm install -g openclaw@latest

WORKDIR /app

ENV PORT=8080
EXPOSE 8080

# Debug mode - lihat apa saja yang tersedia
CMD ["sh", "-c", "echo '=== OpenClaw Debug ===' && echo 'Which openclaw:' && which openclaw && echo '=== Version ===' && openclaw --version 2>&1 || true && echo '=== Help ===' && openclaw --help 2>&1 || true && echo '=== Sleeping... ===' && sleep infinity"]
