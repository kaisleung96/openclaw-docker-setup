# Installation Guide

## Prerequisites

- Docker Desktop (macOS/Windows) or Docker Engine (Linux)
- Git
- Bash shell
- 10GB free disk space

> **Note:** Node.js is **not required** on your host machine. OpenClaw runs entirely inside the Docker container.

## Step-by-Step

### 1. Install Docker

- **macOS/Windows**: Download [Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Linux (Ubuntu/Debian)**: `sudo apt-get install -y docker.io && sudo systemctl start docker`
- **Linux (CentOS/RHEL)**: `sudo yum install -y docker && sudo systemctl start docker`

After installing, verify Docker is running:
```bash
docker ps
```

### 2. Clone Repository

```bash
git clone https://github.com/kaisleung96/openclaw-docker-setup.git
cd openclaw-docker-setup
```

### 3. Run Setup Script

```bash
bash src/openclaw-docker-setup.sh
```

An interactive Chinese CLI menu will appear.

### 4. Create First Instance

Select **option 1** from the menu.

You will be prompted for:

| Prompt | Default | Description |
|--------|---------|-------------|
| Instance name | `openclaw-gateway` | Docker container name |
| Port | `18789` | Host port to access OpenClaw |
| Data directory | `~/openclaw-deployment/openclaw-gateway` | Bind-mount path on host |

Press Enter to accept defaults, or type your own values.

### 5. Run Onboard Wizard

After the container starts, select **option 3** → choose your container → select **option 1** (Run OpenClaw onboard).

This runs inside the container:
```bash
npx openclaw@latest onboard --install-daemon
```

## Verify Installation

### Check container is running

```bash
docker ps --filter "label=openclaw=true"
```

Should show your OpenClaw container with status `Up`.

### Check data directory was created

```bash
ls ~/openclaw-deployment/
```

Should show a directory named after your instance.

### Access Web UI

Open your browser at:
```
http://localhost:18789
```

## Data Storage

All OpenClaw data is stored on your host via bind mount (not Docker named volumes):

```
~/openclaw-deployment/<instance-name>/
├── openclaw.json       # Config file
└── workspace/          # Workspace directory
```

Override the base path:
```bash
OPENCLAW_PATH=/custom/path bash src/openclaw-docker-setup.sh
```

## Uninstall

```bash
# Stop and remove all OpenClaw containers
docker ps -a --filter "label=openclaw=true" -q | xargs docker rm -f

# Remove project directory
rm -rf openclaw-docker-setup

# Optionally remove data
rm -rf ~/openclaw-deployment
```
