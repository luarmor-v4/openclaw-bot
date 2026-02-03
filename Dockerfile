# ============================================
# OpenClaw Docker Image for Render.com
# ============================================

FROM node:22-slim

# Labels
LABEL maintainer="Your Name"
LABEL description="OpenClaw AI Assistant"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    gnupg \
    ca-certificates \
    chromium \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set Puppeteer environment
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Set working directory
WORKDIR /app

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create required directories
RUN mkdir -p /data/.openclaw /data/workspace

# Copy configuration file
COPY openclaw.json /app/openclaw.json
COPY package.json /app/package.json

# Set environment variables
ENV OPENCLAW_STATE_DIR=/data/.openclaw
ENV OPENCLAW_WORKSPACE_DIR=/data/workspace
ENV NODE_ENV=production

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080}/health || exit 1

# Create startup script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "========================================"\n\
echo "🦞 Starting OpenClaw AI Assistant"\n\
echo "========================================"\n\
\n\
# Copy config to state directory if not exists\n\
if [ ! -f "$OPENCLAW_STATE_DIR/openclaw.json" ]; then\n\
    echo "📋 Copying default config..."\n\
    cp /app/openclaw.json $OPENCLAW_STATE_DIR/openclaw.json\n\
fi\n\
\n\
# Start OpenClaw Gateway\n\
echo "🚀 Starting Gateway on port ${PORT:-8080}..."\n\
exec openclaw gateway --port ${PORT:-8080} --bind 0.0.0.0\n\
' > /app/start.sh && chmod +x /app/start.sh

# Start command
CMD ["/app/start.sh"]
