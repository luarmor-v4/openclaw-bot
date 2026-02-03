FROM node:22-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@latest

WORKDIR /app
RUN mkdir -p /root/.openclaw /tmp/workspace

COPY openclaw.json /root/.openclaw/openclaw.json

ENV OPENCLAW_STATE_DIR=/root/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/tmp/workspace
ENV NODE_ENV=production
ENV PORT=8080
ENV NODE_OPTIONS="--max-old-space-size=460"

EXPOSE 8080

CMD ["openclaw", "gateway", "--port", "8080"]
