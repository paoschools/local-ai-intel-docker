# Local AI R&D — Intel Core Ultra / Docker

ชุดเริ่มต้นสำหรับสร้าง Local AI บน Windows 11 ที่ไม่มี NVIDIA GPU โดยแยก **Ollama รันแบบ Native บน Windows** และให้บริการอื่นรันด้วย Docker Desktop

## Services

| Service | URL / Port | Purpose |
|---|---|---|
| Open WebUI | http://localhost:3000 | Chat UI |
| Node-RED | http://localhost:1880 | Workflow / API / RAG orchestration |
| PostgreSQL + pgvector | localhost:5432 | Database / Vector search |
| pgAdmin | http://localhost:8081 | PostgreSQL administration |
| Portainer CE | https://localhost:9443 | Docker administration |
| Ollama Native | http://localhost:11434 | Local / Cloud models |

Portainer CE uses HTTPS on port `9443` by default. pgAdmin is exposed on port `8081`.

## Architecture

```text
Windows 11
├─ Ollama Native
│  └─ http://localhost:11434
│
└─ Docker Desktop / WSL2
   ├─ Open WebUI       :3000
   ├─ Node-RED         :1880
   ├─ PostgreSQL       :5432
   │  └─ pgvector
   ├─ pgAdmin          :8081
   └─ Portainer CE     :9443
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

ระบบจะสร้าง Folder:
```powershell
mkdir D:\Local-AI-INTEL-DOCKER
mkdir D:\Local-AI-INTEL-DOCKER\ollama
mkdir D:\Local-AI-INTEL-DOCKER\ollama\data

mkdir D:\Local-AI-INTEL-DOCKER\open-webui
mkdir D:\Local-AI-INTEL-DOCKER\open-webui\data

mkdir D:\Local-AI-INTEL-DOCKER\postgres
mkdir D:\Local-AI-INTEL-DOCKER\postgres\data

mkdir D:\Local-AI-INTEL-DOCKER\nodered
mkdir D:\Local-AI-INTEL-DOCKER\nodered\data

mkdir D:\Local-AI-INTEL-DOCKER\documents
mkdir D:\Local-AI-INTEL-DOCKER\documents\original
mkdir D:\Local-AI-INTEL-DOCKER\documents\ocr
mkdir D:\Local-AI-INTEL-DOCKER\documents\processed
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
