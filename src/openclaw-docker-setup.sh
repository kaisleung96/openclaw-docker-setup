#!/bin/bash

###############################################
# OpenClaw Docker Setup
# Interactive setup tool for OpenClaw
###############################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

CURRENT_MENU="main"

print_header() {
    clear
    echo -e "${BLUE}"
    cat << "EOF"
╔════════════════════════════════════════════════╗
║                                                ║
║        OpenClaw Docker Setup Tool              ║
║                                                ║
║  • Isolated Docker containers                  ║
║  • Host file safety first                      ║
║  • Official onboard integration                ║
║  • Interactive configuration                   ║
║  • Built-in diagnostics                        ║
║                                                ║
╚════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

step() {
    echo -e "${CYAN}[*]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
}

read_input() {
    local prompt="$1"
    local default="$2"
    read -p "$(echo -e ${CYAN}$prompt${NC}) [$default]: " input
    input="${input:-$default}"
    echo "$input"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed"
        return 1
    fi
    success "Docker installed"
    
    if ! docker ps > /dev/null 2>&1; then
        error "Docker daemon is not running"
        return 1
    fi
    success "Docker daemon is running"
    return 0
}

show_main_menu() {
    print_header
    
    echo ""
    echo "1. 🚀 Create new OpenClaw container"
    echo "2. 📋 Manage containers"
    echo "3. 🔧 Enter container"
    echo "4. 🏥 Diagnostics"
    echo "5. 📚 Help"
    echo "6. ❌ Exit"
    echo ""
    
    local choice=$(read_input "Select operation" "1")
    
    case "$choice" in
        1) create_container ;;
        2) manage_containers ;;
        3) enter_container ;;
        4) run_diagnostics ;;
        5) show_help ;;
        6) echo ""; echo "Goodbye!"; exit 0 ;;
        *) error "Invalid choice"; sleep 1; CURRENT_MENU="main" ;;
    esac
}

create_container() {
    echo ""
    local name=$(read_input "Container name" "openclaw-sandbox")
    local port=$(read_input "Port" "18789")
    
    echo ""
    step "Creating isolated container..."
    
    docker run -d \
        --name "$name" \
        --restart unless-stopped \
        --label "openclaw=true" \
        -p "$port:18789" \
        -v openclaw_data:/home/node/.openclaw \
        ghcr.io/openclaw/openclaw:latest
    
    success "Container created: $name"
    echo ""
    echo "🌐 Access at: http://localhost:$port"
    echo ""
    echo "To run onboard:"
    echo "  docker exec -it $name npx openclaw@latest onboard"
    echo ""
    echo "To view logs:"
    echo "  docker logs -f $name"
    echo ""
    
    read_input "Press Enter to continue"
    CURRENT_MENU="main"
}

manage_containers() {
    echo ""
    echo "🐳 OpenClaw containers:"
    docker ps -a --filter "label=openclaw=true" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || echo "No containers found"
    echo ""
    
    read_input "Press Enter to continue"
    CURRENT_MENU="main"
}

enter_container() {
    echo ""
    local name=$(read_input "Container name" "openclaw-sandbox")
    
    if ! docker ps -a --filter "name=$name" --quiet &> /dev/null; then
        error "Container not found"
        sleep 1
        CURRENT_MENU="main"
        return
    fi
    
    echo ""
    echo "Entering container: $name"
    echo "Type 'exit' to leave"
    echo ""
    
    docker exec -it "$name" bash || true
    CURRENT_MENU="main"
}

run_diagnostics() {
    echo ""
    step "Running diagnostics..."
    echo ""
    
    echo "Docker status:"
    docker ps -a --filter "label=openclaw=true" || echo "No containers found"
    
    echo ""
    echo "Volumes:"
    docker volume ls || echo "No volumes found"
    
    echo ""
    read_input "Press Enter to continue"
    CURRENT_MENU="main"
}

show_help() {
    echo ""
    echo "📚 Quick Start Guide"
    echo ""
    echo "1️⃣  Create a container:"
    echo "   Select menu 1 and follow prompts"
    echo ""
    echo "2️⃣  Run onboard:"
    echo "   docker exec -it <container_name> npx openclaw@latest onboard"
    echo ""
    echo "3️⃣  Access OpenClaw:"
    echo "   Open browser to http://localhost:18789"
    echo ""
    echo "4️⃣  View logs:"
    echo "   docker logs -f <container_name>"
    echo ""
    echo "5️⃣  Stop container:"
    echo "   docker stop <container_name>"
    echo ""
    echo "6️⃣  Remove container:"
    echo "   docker rm <container_name>"
    echo ""
    
    read_input "Press Enter to continue"
    CURRENT_MENU="main"
}

main_loop() {
    while true; do
        case "$CURRENT_MENU" in
            main) show_main_menu ;;
        esac
    done
}

# 检查前置条件
if ! check_docker; then
    echo ""
    echo "Please install Docker: https://docker.com/products/docker-desktop"
    exit 1
fi

echo ""
main_loop
