FROM node:22-slim

# Install dependencies
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
ENV PORT=8080

EXPOSE 8080

# Debug: cek command yang tersedia
RUN openclaw --help || echo "openclaw --help failed"
RUN openclaw --version || echo "openclaw --version failed"

# Start dengan logging
CMD ["sh", "-c", "echo 'Starting OpenClaw...' && echo 'PORT='$PORT && openclaw serve --port $PORT --host 0.0.0.0 || openclaw gateway --port $PORT --bind 0.0.0.0 || openclaw start --port $PORT || echo 'All commands failed' && sleep infinity"]
