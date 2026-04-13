# Installation Guide

## Prerequisites

- Docker Desktop (macOS/Windows) or Docker Engine (Linux)
- Bash shell
- 5GB free disk space

## Step-by-Step

### 1. Install Docker

- **macOS/Windows**: Download [Docker Desktop](https://docker.com/products/docker-desktop)
- **Linux**: `sudo apt-get install docker.io`

### 2. Clone Repository

```bash
git clone https://github.com/kaisleung96/openclaw-docker-setup.git
cd openclaw-docker-setup
```

### 3. Run Setup Script

```bash
bash src/openclaw-docker-setup.sh
```

### 4. Create First Container

Follow the interactive prompts to create your first OpenClaw container.

## Verify Installation

```bash
docker ps --filter "label=openclaw=true"
```

Should show your OpenClaw container.
