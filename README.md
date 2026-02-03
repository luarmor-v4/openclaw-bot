# 🦞 OpenClaw Bot - Render.com Deployment

Personal AI Assistant dengan Discord Integration menggunakan model GRATIS dari OpenRouter.

## 🚀 Quick Deploy

### Prerequisites

1. **OpenRouter Account** (Gratis)
   - Daftar: https://openrouter.ai
   - Buat API Key: https://openrouter.ai/keys

2. **Discord Bot**
   - Buat: https://discord.com/developers/applications
   - Aktifkan MESSAGE CONTENT INTENT

3. **Render Account**
   - Daftar: https://render.com

---

## 📋 Langkah Deploy

### Step 1: Siapkan Discord Bot

1. Buka [Discord Developer Portal](https://discord.com/developers/applications)
2. Klik **New Application** → Beri nama
3. Masuk tab **Bot** → **Add Bot**
4. Klik **Reset Token** → **Copy** (simpan!)
5. Scroll ke **Privileged Gateway Intents**
6. Aktifkan:
   - ✅ PRESENCE INTENT
   - ✅ SERVER MEMBERS INTENT  
   - ✅ MESSAGE CONTENT INTENT ← **WAJIB!**
7. Masuk tab **OAuth2** → **URL Generator**
8. Centang scope: `bot`
9. Centang permissions:
   - Send Messages
   - Read Message History
   - Embed Links
   - Attach Files
   - Add Reactions
10. Copy URL → Buka di browser → Invite ke server

### Step 2: Deploy ke Render

1. Fork/Upload repository ini ke GitHub
2. Buka [Render Dashboard](https://dashboard.render.com)
3. Klik **New** → **Blueprint**
4. Connect repository GitHub
5. Render akan membaca `render.yaml` otomatis
6. Isi Environment Variables:

| Variable | Value |
|----------|-------|
| `SETUP_PASSWORD` | Password Anda sendiri |
| `OPENROUTER_API_KEY` | `sk-or-v1-xxx...` |
| `DISCORD_BOT_TOKEN` | `MTxxx...` |

7. Klik **Apply** → Tunggu deploy selesai

### Step 3: Setup & Test

1. Buka: `https://your-app.onrender.com/setup`
2. Masukkan SETUP_PASSWORD
3. Ikuti wizard konfigurasi
4. Test bot di Discord:
