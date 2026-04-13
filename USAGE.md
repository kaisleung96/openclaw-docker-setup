# Usage Guide

## Quick Start

### Step 1: Run the setup script

```bash
bash src/openclaw-docker-setup.sh
```

### Step 2: Select menu option 1

Create a new isolated OpenClaw container with:
- Container name
- Port number

### Step 3: Run onboard

```bash
docker exec -it <container_name> npx openclaw@latest onboard
```

## Menu Options

- **1**: Create container
- **2**: Manage containers
- **3**: Enter container
- **4**: Diagnostics
- **5**: Help
- **6**: Exit

## Common Tasks

### View running containers

```bash
docker ps --filter "label=openclaw=true"
```

### View container logs

```bash
docker logs -f <container_name>
```

### Stop a container

```bash
docker stop <container_name>
```

### Remove a container

```bash
docker rm <container_name>
```

## Data Persistence

Data is stored in Docker volumes for easy backup and management.

## Network Access

By default, OpenClaw is accessible at `http://localhost:18789`

You can change the port when creating the container.
