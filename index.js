const http = require('http');
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// === BAGIAN 1: WEB SERVER (Agar Replit tidak tidur) ===
const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end('OpenClaw is Running');
});
server.listen(3000, () => console.log('✅ Web Server Ready'));

// === BAGIAN 2: AUTO-FIX CONFIGURASI (Pengganti Shell) ===
function fixConfig() {
  console.log('🔧 Memperbaiki Konfigurasi secara Otomatis...');

  // 1. Ambil API Key & Token dari Secrets Replit
  const telegramToken = process.env.TELEGRAM_BOT_TOKEN;
  const openRouterKey = process.env.OPENROUTER_API_KEY;

  if (!telegramToken || !openRouterKey) {
    console.error('❌ ERROR FATAL: Secret TELEGRAM_BOT_TOKEN atau OPENROUTER_API_KEY belum diisi di menu Secrets/Tools!');
    return false;
  }

  // 2. Tentukan lokasi file config
  const configDir = path.join(os.homedir(), '.config', 'openclaw');
  const configFile = path.join(configDir, 'config.json');

  // 3. Buat folder jika belum ada
  if (!fs.existsSync(configDir)) {
    fs.mkdirSync(configDir, { recursive: true });
  }

  // 4. Tulis Konfigurasi yang BENAR (Memaksa Telegram Aktif)
  const configContent = {
    "gateway": {
      "mode": "local"
    },
    "telegram": {
      "enabled": true,  // <--- INI KUNCINYA (Memaksa Aktif)
      "token": telegramToken
    },
    "ai": {
      "provider": "openrouter",
      "apiKey": openRouterKey,
      "model": "deepseek/deepseek-chat", 
      "endpoint": "https://openrouter.ai/api/v1"
    },
    "security": {
      "sandboxMode": true,
      "approvalMode": "ask"
    }
  };

  // 5. Simpan file config
  fs.writeFileSync(configFile, JSON.stringify(configContent, null, 2));
  console.log('✅ Konfigurasi berhasil diperbaiki!');
  return true;
}

// === BAGIAN 3: JALANKAN BOT ===
function startBot() {
  // Jalankan perbaikan config dulu sebelum start
  if (!fixConfig()) return;

  console.log('🚀 Starting OpenClaw (Low Memory Mode)...');
  
  const bot = spawn('node', ['--max-old-space-size=400', 'node_modules/.bin/openclaw', 'gateway'], {
    stdio: 'inherit',
    shell: true,
    env: { ...process.env, NODE_OPTIONS: '--max-old-space-size=400' }
  });

  bot.on('close', (code) => {
    console.log(`⚠️ Bot stopped (Code ${code}). Restarting in 5s...`);
    setTimeout(startBot, 5000);
  });
}

// Mulai
startBot();
