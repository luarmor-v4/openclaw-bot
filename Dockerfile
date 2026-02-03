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
ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "\
    echo '=== Gateway Help ===' && \
    openclaw gateway --help 2>&1 && \
    echo '' && \
    echo '=== Gateway Start Help ===' && \
    openclaw gateway start --help 2>&1 && \
    echo '' && \
    echo '=== Trying to start ===' && \
    openclaw gateway start --port 8080 --host 0.0.0.0 2>&1 & \
    sleep 5 && \
    echo '=== Check if running ===' && \
    curl -s http://localhost:8080/health 2>&1 || echo 'Health check failed' && \
    tail -f /dev/null \
"]
