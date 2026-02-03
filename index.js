const http = require('http');
const { spawn } = require('child_process');

// 1. Web Server Minimalis (Hemat RAM)
const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end('OK');
});

server.listen(3000, () => console.log('✅ Server OK'));

// 2. Bot Runner dengan Auto-Restart & Garbage Collection
function startBot() {
  console.log('🚀 Starting OpenClaw (Low Memory Mode)...');
  
  // Tambahkan flag --max-old-space-size agar Node.js tau diri soal RAM
  const bot = spawn('node', ['--max-old-space-size=400', 'node_modules/.bin/openclaw', 'gateway'], {
    stdio: 'inherit',
    shell: true,
    env: { ...process.env, NODE_OPTIONS: '--max-old-space-size=400' }
  });

  bot.on('close', (code) => {
    console.log(`⚠️ Bot crash/stopped (Code ${code}). Restarting in 10s...`);
    // Jeda 10 detik biar CPU nafas dulu
    setTimeout(startBot, 10000);
  });
}

startBot();
