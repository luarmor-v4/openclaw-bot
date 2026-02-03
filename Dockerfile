FROM node:22-slim

# Install dependencies - TAMBAH git!
RUN apt-get update && apt-get install -y \
    curl \
    git \
    chromium \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN npm install -g openclaw@latest

WORKDIR /app
RUN mkdir -p /tmp/.openclaw /tmp/workspace

COPY openclaw.json /tmp/.openclaw/openclaw.json

ENV OPENCLAW_STATE_DIR=/tmp/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/tmp/workspace
ENV NODE_ENV=production

EXPOSE 8080

CMD ["sh", "-c", "openclaw gateway --port ${PORT:-8080} --bind 0.0.0.0"]
