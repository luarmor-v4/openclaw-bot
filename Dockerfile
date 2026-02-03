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
RUN mkdir -p /tmp/.openclaw /tmp/workspace

COPY openclaw.json /tmp/.openclaw/openclaw.json

ENV OPENCLAW_STATE_DIR=/tmp/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/tmp/workspace
ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "\
    echo '=== OpenClaw Debug ===' && \
    echo 'PORT='$PORT && \
    echo '' && \
    echo '=== Which openclaw ===' && \
    which openclaw 2>&1 && \
    echo '' && \
    echo '=== Version ===' && \
    openclaw --version 2>&1 && \
    echo '' && \
    echo '=== Help ===' && \
    openclaw --help 2>&1 && \
    echo '' && \
    echo '=== List Commands ===' && \
    openclaw 2>&1 && \
    echo '' && \
    echo '=== Trying to start ===' && \
    openclaw serve --port $PORT --host 0.0.0.0 2>&1 || \
    openclaw gateway --port $PORT --bind 0.0.0.0 2>&1 || \
    openclaw start --port $PORT 2>&1 || \
    openclaw run 2>&1 || \
    echo 'All start commands failed' && \
    echo '=== Keeping alive ===' && \
    tail -f /dev/null \
"]
