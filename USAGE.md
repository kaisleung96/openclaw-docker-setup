# Usage Guide

## Quick Start

### Step 1: Run the setup script

```bash
bash src/openclaw-docker-setup.sh
```

On first launch you will be prompted to choose a language:

```
  ╔════════════════════════════════════════════════╗
  ║       OpenClaw Setup Tool v1.0.0             ║
  ╚════════════════════════════════════════════════╝

  Select language / 选择语言:

  1. English  (default)
  2. 中文

  [1]:
```

Press **Enter** (or type `1`) for English. Type `2` for Chinese (中文).

The interactive menu then appears:

```
╔════════════════════════════════════════════════╗
║                                                ║
║   OpenClaw 交互式安装配置工具 v1.0              ║
║   集成官方 onboard 安装流程                     ║
║                                                ║
║   • 一键创建 Docker 容器                        ║
║   • 自动进入 OpenClaw onboard 流程              ║
║   • 交互式配置和管理                            ║
║   • 飞书集成向导                                ║
║   • 故障诊断和修复                              ║
║                                                ║
╚════════════════════════════════════════════════╝

1. 🚀 创建新的 OpenClaw（Docker + 完整安装）
2. 📋 管理现有 OpenClaw 实例
3. 🔧 进入容器进行高级操作
4. 🏥 故障诊断和修复
5. 📚 帮助和文档
6. ❌ 退出
```

### Step 2: Create a new OpenClaw instance (menu option 1)

You will be prompted for:

| Prompt | Default | Description |
|--------|---------|-------------|
| Instance name | `openclaw-gateway` | Docker container name |
| Port | `18789` | Host port to access OpenClaw |
| Data directory | `~/openclaw-deployment/openclaw-gateway` | Bind-mount path on host |

The script will:
1. Create the data directory on your host
2. Pull and start the `ghcr.io/openclaw/openclaw:latest` container
3. Wait up to 60 seconds for OpenClaw to become ready
4. Display connection info

### Step 3: Run onboard (menu option 3 → option 1)

```
Select menu 3 → choose your container → select 1 (Run OpenClaw onboard)
```

This runs inside the container:
```bash
npx openclaw@latest onboard --install-daemon
```

Onboard guides you through:
1. Gateway configuration (port, authentication)
2. Workspace configuration
3. LLM model (OpenAI / Claude / Gemini / etc.)
4. Communication channels (WhatsApp / Telegram / Slack / etc.)
5. Skills and plugins

### Step 4: Access OpenClaw

Open your browser at:
```
http://localhost:18789
```

Control panel:
```
http://localhost:18789/control
```

## Menu Options

### Option 1 — 创建新的 OpenClaw

Creates a new container with:
- `--restart unless-stopped`
- Bind mount: `<data-path>:/home/node/.openclaw`
- Bind mount: `<data-path>/workspace:/workspace`
- Label: `openclaw=true`
- `NODE_ENV=production`

### Option 2 — 管理现有 OpenClaw 实例

Lists all containers with label `openclaw=true` (including stopped ones).

Sub-operations per instance:
1. ✅ Start
2. ❌ Stop
3. 🔄 Restart
4. 📊 View status
5. 📜 View logs
6. 🗑️  Delete
7. ⬅️  Return

### Option 3 — 进入容器进行高级操作

Lists all **running** containers with label `openclaw=true`.

Sub-operations:
1. 🚀 Run OpenClaw onboard (`npx openclaw@latest onboard --install-daemon`)
2. 🔧 Run a custom command inside the container
3. 💻 Open an interactive Bash shell
4. 📜 Follow container logs (`docker logs -f`)
5. ⬅️  Return

### Option 4 — 故障诊断和修复

Diagnostics and auto-fix tools:

1. 🔍 System diagnostics (Docker installed, daemon running, Node.js)
2. 🐳 Docker diagnostics (list all OpenClaw containers)
3. 📊 View all Docker containers
4. 🔧 Auto-fix sub-menu:
   - Restart all OpenClaw containers
   - `docker system prune -f`
   - Pull latest `ghcr.io/openclaw/openclaw:latest`
5. ⬅️  Return

### Option 5 — 帮助和文档

Displays quick-start steps and common commands.

### Option 6 — 退出

Exits the script.

## Data Storage

All data is stored via bind mount on your host, not in Docker named volumes.

Default location:
```
~/openclaw-deployment/<instance-name>/
├── openclaw.json       # OpenClaw config
└── workspace/          # Workspace files
```

Override the base directory:
```bash
OPENCLAW_PATH=/your/custom/path bash src/openclaw-docker-setup.sh
```

## Common Commands

### View running OpenClaw containers

```bash
docker ps --filter "label=openclaw=true"
```

### View all OpenClaw containers (including stopped)

```bash
docker ps -a --filter "label=openclaw=true"
```

### View container logs

```bash
docker logs -f <container_name>
```

### Enter container shell

```bash
docker exec -it <container_name> bash
```

### Run onboard manually

```bash
docker exec -it <container_name> npx openclaw@latest onboard --install-daemon
```

### Run OpenClaw commands inside container

```bash
# Start Gateway
docker exec -it <container_name> openclaw gateway --port 18789

# Diagnose issues
docker exec -it <container_name> openclaw doctor

# Send a message to the AI agent
docker exec -it <container_name> openclaw agent "Hello"
```

### Stop / Start / Restart a container

```bash
docker stop <container_name>
docker start <container_name>
docker restart <container_name>
```

### Delete a container

```bash
docker stop <container_name>
docker rm <container_name>
```

## Multiple Instances

Each instance needs a unique name and port:

```bash
# Production
bash src/openclaw-docker-setup.sh
# Name: openclaw-prod   Port: 18789

# Testing
bash src/openclaw-docker-setup.sh
# Name: openclaw-test   Port: 18790

# Development
bash src/openclaw-docker-setup.sh
# Name: openclaw-dev    Port: 18791
```

View all instances and their ports via menu option 2, or:

```bash
docker ps -a --filter "label=openclaw=true" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

## Network Access

By default, OpenClaw is accessible at `http://localhost:18789`.  
The port is determined by your input when creating the instance.
