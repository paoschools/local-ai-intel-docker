# Local AI R&D — Intel Core Ultra / Docker

ชุดเริ่มต้นสำหรับสร้าง Local AI บน Windows 11 ที่ไม่มี NVIDIA GPU โดยแยก **Ollama รันแบบ Native บน Windows** และให้บริการอื่นรันด้วย Docker Desktop

## Architecture

```text
Windows 11
├─ Ollama Native
│  └─ http://localhost:11434
│
└─ Docker Desktop / WSL2
   ├─ Open WebUI       :3000
   ├─ Node-RED         :1880
   └─ PostgreSQL
      └─ pgvector      :5432
```

Container ติดต่อ Ollama บน Windows ผ่าน:

```text
http://host.docker.internal:11434
```

## Requirements

- Windows 11
- Intel Core Ultra / Intel integrated graphics
- RAM แนะนำ 16 GB ขึ้นไป
- Docker Desktop + WSL2
- Ollama for Windows
- Git (กรณีต้องการนำ repository ขึ้น GitHub)

> โครงการนี้ไม่กำหนด NVIDIA GPU reservation ใน Docker Compose

## 1. เตรียมโฟลเดอร์

เปิด PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\setup-folders.ps1
```

ระบบจะสร้าง:

```text
D:\Local-AI\
├─ open-webui\data
├─ postgres\data
├─ nodered\data
└─ documents
   ├─ original
   ├─ ocr
   └─ processed
```

## 2. ติดตั้งและทดสอบ Ollama

ติดตั้ง Ollama บน Windows แล้วตรวจสอบ:

```powershell
ollama --version
ollama list
```

ทดลองโมเดลขนาดเล็กก่อน:

```powershell
ollama pull qwen2.5:3b
ollama pull qwen2.5-coder:3b
ollama pull nomic-embed-text
```

ทดสอบ:

```powershell
ollama run qwen2.5:3b
```

## 3. ตรวจสอบ Ollama API

บน Windows:

```powershell
curl http://localhost:11434/api/tags
```

หาก Docker container ติดต่อ Ollama ไม่ได้ ให้ตรวจสอบว่า Ollama อนุญาตการเชื่อมต่อจาก host interface ที่ Docker Desktop เข้าถึงได้

## 4. Start Docker Stack

จาก directory ของ repository:

```powershell
docker compose pull
docker compose up -d
docker compose ps
```

## 5. เปิดระบบ

- Open WebUI: `http://localhost:3000`
- Node-RED: `http://localhost:1880`
- PostgreSQL: `localhost:5432`
- Ollama API บน Windows: `http://localhost:11434`

## PostgreSQL

ค่าเริ่มต้น:

```text
Database: local_ai
User:     local_ai
Password: change_this_password
Port:     5432
```

**ควรเปลี่ยน password ก่อนใช้งานจริง**

จาก Node-RED ให้ใช้ host:

```text
postgres
```

ไม่ใช่ `localhost`

## Ollama จาก Docker

Open WebUI และ Node-RED ใช้:

```text
http://host.docker.internal:11434
```

เพราะ Ollama รันบน Windows host ไม่ได้อยู่ใน Docker network

## Document AI / RAG

เตรียม directory ไว้สำหรับขั้นต่อไป:

```text
D:\Local-AI\documents\original
D:\Local-AI\documents\ocr
D:\Local-AI\documents\processed
```

แนวทางระบบ:

```text
Paper / Scan
   ↓
PDF / Image
   ↓
OCR
   ↓
Chunking
   ↓
Embedding
   ↓
PostgreSQL + pgvector
   ↓
RAG Search
   ↓
Ollama
   ↓
Answer + Document/Page Reference
```

`nomic-embed-text` สามารถใช้เป็น embedding model ในระยะเริ่มต้นได้

## Stop / Restart

```powershell
docker compose stop
docker compose start
```

หรือ:

```powershell
docker compose down
docker compose up -d
```

ข้อมูลยังอยู่ใน `D:\Local-AI` เนื่องจากใช้ bind mounts

## Update

```powershell
docker compose pull
docker compose up -d
```

อัปเดต Ollama for Windows แยกจาก Docker stack

## GitHub

สร้าง repository:

```powershell
git init
git add .
git commit -m "Initial Local AI Docker stack"
git branch -M main
git remote add origin <YOUR_GITHUB_REPOSITORY>
git push -u origin main
```

อย่า commit password จริง, API key หรือข้อมูลเอกสารภายในองค์กรขึ้น public repository

## Files

```text
.
├─ docker-compose.yml
├─ README.md
├─ setup-folders.ps1
├─ .env.example
└─ .gitignore
```

## Next Phase

แนะนำเพิ่มบริการต่อไปนี้ภายหลัง:

1. OCR สำหรับเอกสารภาษาไทย
2. Document ingestion API
3. Chunking
4. pgvector indexing
5. Hybrid keyword + vector search
6. RAG API
7. Angular frontend
8. Citation ที่ระบุชื่อเอกสารและเลขหน้า

