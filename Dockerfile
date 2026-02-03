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
RUN mkdir -p /root/.openclaw /tmp/workspace

COPY openclaw.json /root/.openclaw/openclaw.json

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/tmp/workspace
ENV NODE_ENV=production
ENV PORT=8080
ENV HOST=0.0.0.0

EXPOSE 8080

CMD ["sh", "-c", "echo 'Starting OpenClaw Gateway...' && openclaw gateway start --port $PORT --host $HOST 2>&1 || openclaw gateway --port $PORT 2>&1 || (echo 'Trying with config...' && openclaw gateway 2>&1)"]
