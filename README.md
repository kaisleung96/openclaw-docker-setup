# openclaw-docker-setup

🚀 Automated setup scripts for running OpenClaw in an isolated Docker sandbox

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Release](https://img.shields.io/github/v/release/kaisleung96/openclaw-docker-setup)](https://github.com/kaisleung96/openclaw-docker-setup/releases)
[![GitHub Stars](https://img.shields.io/github/stars/kaisleung96/openclaw-docker-setup)](https://github.com/kaisleung96/openclaw-docker-setup)

**English** | [中文文档](docs/README-CN.md)

## ✨ Features

- 🐳 **Docker Sandbox Setup** - Create isolated OpenClaw containers quickly
- 🔐 **Host Isolation First** - Reduce risk of touching files on your local machine
- 🚀 **Official Onboard Integration** - Complete OpenClaw setup wizard (with `--install-daemon`)
- ⚙️ **Interactive CLI** - Chinese interactive menu for setup and management
- 🏥 **Diagnostics & Repair** - Built-in troubleshooting and auto-fix tools

## 🎯 Quick Start

### Prerequisites

- Docker and Docker Daemon running
- Bash shell

### Installation

```bash
git clone https://github.com/kaisleung96/openclaw-docker-setup.git
cd openclaw-docker-setup
bash src/openclaw-docker-setup.sh
```

### Usage

```
1. Run the script — an interactive Chinese menu appears
2. Select option 1 to create a new OpenClaw instance
3. Enter instance name (default: openclaw-gateway) and port (default: 18789)
4. Wait for the container to start
5. Select option 3 → option 1 to run the onboard wizard
6. Done! ✅  Access at http://localhost:18789
```

## 📋 Menu Overview

| Option | Function | Description |
|--------|----------|-------------|
| 1 | 创建新的 OpenClaw | Create container + data directory |
| 2 | 管理现有实例 | Start / Stop / Restart / Delete |
| 3 | 进入容器高级操作 | Run onboard, custom commands, shell, logs |
| 4 | 故障诊断和修复 | System diagnostics, Docker diagnostics, auto-fix |
| 5 | 帮助和文档 | Quick-start guide and command reference |
| 6 | 退出 | Exit |

## 🗂️ Data Storage

All OpenClaw data is stored on your host machine via bind mount:

```
~/openclaw-deployment/<instance-name>/
├── openclaw.json       # Config file
└── workspace/          # Workspace directory
```

You can override the base path with the `OPENCLAW_PATH` environment variable:

```bash
OPENCLAW_PATH=/custom/path bash src/openclaw-docker-setup.sh
```

## 🔧 Running Onboard

After creating a container, run the official OpenClaw onboard wizard:

**Via menu (recommended):**
```
Select menu 3 → choose container → select 1 (Run onboard)
```

**Or directly:**
```bash
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

Onboard will guide you through:
1. Gateway configuration (port, authentication)
2. Workspace setup
3. LLM model selection (OpenAI / Claude / Gemini / etc.)
4. Communication channel setup (WhatsApp / Telegram / Slack / etc.)
5. Skills and plugin configuration

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Full Usage Guide](USAGE.md)
- [中文文档](docs/README-CN.md)

## 🔒 Security First

All OpenClaw data and configuration runs inside Docker containers. Your host machine remains clean and isolated.

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## 📄 License

MIT License - See [LICENSE](LICENSE)
---

Made by kaisleung96
