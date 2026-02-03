const http = require('http');
const { spawn, execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// ========== 1. WEB SERVER (Wajib untuk Render) ==========
const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`
    <html>
      <head><title>OpenClaw Bot</title></head>
      <body style="font-family: Arial; text-align: center; padding: 50px;">
        <h1>🤖 OpenClaw Bot is Running!</h1>
        <p>Bot aktif dan siap menerima pesan di Telegram.</p>
        <p>Status: <strong style="color: green;">ONLINE</strong></p>
      </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log(`✅ Web Server Ready on port ${PORT}`);
});

// ========== 2. AUTO-FIX CONFIG ==========
function createConfig() {
  console.log('🔧 Membuat Konfigurasi...');

  const telegramToken = process.env.TELEGRAM_BOT_TOKEN;
  const openRouterKey = process.env.OPENROUTER_API_KEY;

  // Cek apakah Secrets sudah diisi
  if (!telegramToken) {
    console.error('❌ ERROR: TELEGRAM_BOT_TOKEN belum diisi di Environment Variables!');
    return false;
  }
  if (!openRouterKey) {
    console.error('❌ ERROR: OPENROUTER_API_KEY belum diisi di Environment Variables!');
    return false;
  }

  // Buat folder config
  const configDir = path.join(os.homedir(), '.config', 'openclaw');
  const configFile = path.join(configDir, 'config.json');

  if (!fs.existsSync(configDir)) {
    fs.mkdirSync(configDir, { recursive: true });
    console.log('📁 Folder config dibuat');
  }

  // Tulis konfigurasi lengkap
  const config = {
    "gateway": {
      "mode": "local"
    },
    "telegram": {
      "enabled": true,
      "token": telegramToken
    },
    "ai": {
      "provider": "openrouter",
      "endpoint": "https://openrouter.ai/api/v1",
      "apiKey": openRouterKey,
      "model": "deepseek/deepseek-chat"
    },
    "security": {
      "sandboxMode": true,
      "approvalMode": "ask"
    }
  };

  fs.writeFileSync(configFile, JSON.stringify(config, null, 2));
  console.log('✅ Konfigurasi berhasil dibuat:', configFile);
  
  // Tampilkan isi config untuk verifikasi
  console.log('📋 Isi Config:', JSON.stringify(config, null, 2));
  
  return true;
}

// ========== 3. FORCE FIX VIA CLI ==========
function forceFixViaCLI() {
  console.log('🔧 Menjalankan Force Fix via CLI...');
  
  try {
    execSync('npx openclaw config set gateway.mode local', { stdio: 'inherit' });
    execSync('npx openclaw config set telegram.enabled true', { stdio: 'inherit' });
    
    if (process.env.TELEGRAM_BOT_TOKEN) {
      execSync(`npx openclaw config set telegram.token "${process.env.TELEGRAM_BOT_TOKEN}"`, { stdio: 'inherit' });
    }
    
    if (process.env.OPENROUTER_API_KEY) {
      execSync('npx openclaw config set ai.provider openrouter', { stdio: 'inherit' });
      execSync('npx openclaw config set ai.endpoint https://openrouter.ai/api/v1', { stdio: 'inherit' });
      execSync(`npx openclaw config set ai.apiKey "${process.env.OPENROUTER_API_KEY}"`, { stdio: 'inherit' });
      execSync('npx openclaw config set ai.model deepseek/deepseek-chat', { stdio: 'inherit' });
    }
    
    // Jalankan doctor --fix
    execSync('npx openclaw doctor --fix', { stdio: 'inherit', input: 'y\n' });
    
    console.log('✅ Force Fix selesai!');
  } catch (err) {
    console.log('⚠️ CLI Fix error (lanjut saja):', err.message);
  }
}

// ========== 4. START BOT ==========
function startBot() {
  // Step 1: Buat config file dulu
  if (!createConfig()) {
    console.error('❌ Gagal membuat config. Cek Environment Variables!');
    setTimeout(startBot, 30000); // Coba lagi dalam 30 detik
    return;
  }

  // Step 2: Force fix via CLI
  forceFixViaCLI();

  // Step 3: Jalankan bot dengan flag --allow-unconfigured sebagai backup
  console.log('🚀 Menjalankan OpenClaw Gateway...');
  
  const bot = spawn('npx', ['openclaw', 'gateway', '--allow-unconfigured'], {
    stdio: 'inherit',
    shell: true,
    env: { 
      ...process.env, 
      NODE_OPTIONS: '--max-old-space-size=450'
    }
  });

  bot.on('error', (err) => {
    console.error('❌ Bot Error:', err.message);
  });

  bot.on('close', (code) => {
    console.log(`⚠️ Bot berhenti (Code ${code}). Restart dalam 10 detik...`);
    setTimeout(startBot, 10000);
  });
}

// ========== 5. MULAI ==========
console.log('═══════════════════════════════════════');
console.log('   🤖 OPENCLAW BOT - RENDER EDITION');
console.log('═══════════════════════════════════════');

startBot();
