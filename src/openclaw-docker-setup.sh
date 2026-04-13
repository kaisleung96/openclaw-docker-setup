#!/bin/bash

###############################################
# OpenClaw Interactive CLI Tool
# Supports official onboard installation flow
# Usage: bash openclaw-docker-setup.sh
###############################################

set -e

# ==================== Global Variables ====================
SCRIPT_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_PATH="${OPENCLAW_PATH:-$HOME/openclaw-deployment}"

# Language: "en" (default) or "zh"
LANG_CHOICE="en"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Menu state
CURRENT_MENU="main"

# ==================== Language Selection ====================

select_language() {
    clear
    echo ""
    echo -e "${CYAN}  ╔════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║       OpenClaw Setup Tool v${SCRIPT_VERSION}             ║${NC}"
    echo -e "${CYAN}  ╚════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  Select language / 选择语言:"
    echo ""
    echo "  1. English  (default)"
    echo "  2. 中文"
    echo ""
    read -p "  [1]: " _lang_input
    _lang_input="${_lang_input:-1}"
    case "$_lang_input" in
        2|zh|ZH|cn|CN) LANG_CHOICE="zh" ;;
        *) LANG_CHOICE="en" ;;
    esac
    load_strings
}

# ==================== String Table ====================

load_strings() {
    if [ "$LANG_CHOICE" = "zh" ]; then
        # Utility
        S_INVALID_YN="请输入 y 或 n"
        S_PRESS_ENTER="按 Enter 继续"
        S_PRESS_ENTER_BACK="按 Enter 返回"
        S_INVALID_CHOICE="无效的选择"
        S_YES_NO_SUFFIX="(y/n)"
        # Docker checks
        S_DOCKER_NOT_INSTALLED="Docker 未安装"
        S_DOCKER_INSTALLED="Docker 已安装:"
        S_DOCKER_NOT_RUNNING="Docker daemon 未运行"
        S_DOCKER_RUNNING="Docker daemon 正在运行"
        S_NODE_NOT_ON_HOST="Node.js 未在宿主机安装（容器内会自动安装）"
        S_NODE_INSTALLED="Node.js 已安装:"
        # Main menu
        S_MAIN_MENU="主菜单"
        S_MENU_1="1. 🚀 创建新的 OpenClaw（Docker + 完整安装）"
        S_MENU_2="2. 📋 管理现有 OpenClaw 实例"
        S_MENU_3="3. 🔧 进入容器进行高级操作"
        S_MENU_4="4. 🏥 故障诊断和修复"
        S_MENU_5="5. 📚 帮助和文档"
        S_MENU_6="6. ❌ 退出"
        S_SELECT_OP="请选择操作"
        S_GOODBYE="再见！"
        # Deploy menu
        S_DEPLOY_TITLE="创建新的 OpenClaw"
        S_DOCKER_REQUIRED="请先安装并启动 Docker"
        S_CONFIGURE_INSTANCE="配置新实例:"
        S_INSTANCE_NAME_PROMPT="实例名称"
        S_PORT_PROMPT="访问端口"
        S_DATA_DIR_PROMPT="数据目录"
        S_INSTANCE_CONFIG="实例配置:"
        S_NAME_LABEL="  名称："
        S_PORT_LABEL="  端口："
        S_DATA_DIR_LABEL="  数据目录："
        S_CONFIRM_CREATE="确认创建此实例?"
        # Deploy steps
        S_CREATING_DIR="创建项目目录..."
        S_DIR_CREATED="目录已创建:"
        S_STARTING_CONTAINER="启动 OpenClaw Docker 容器..."
        S_CONTAINER_STARTED="Docker 容器已启动"
        S_WAITING_CONTAINER="等待容器完全启动..."
        S_WAITED_LABEL="已等待:"
        S_OPENCLAW_READY="OpenClaw 已就绪！"
        S_NEXT_STEPS="📋 接下来的步骤:"
        S_STEP1="1️⃣  启动 OpenClaw onboard 安装流程"
        S_STEP1_DESC="   选择菜单: 3 → 进入容器 → 运行 onboard"
        S_STEP2="2️⃣  或者访问 Web UI"
        S_STEP2_URL="   打开浏览器访问:"
        S_STEP3="3️⃣  完成 onboard 安装"
        S_STEP3_GW="   - 配置 Gateway"
        S_STEP3_WS="   - 配置工作空间"
        S_STEP3_CH="   - 配置频道（WhatsApp/Telegram/Slack 等）"
        S_STEP3_LLM="   - 配置 LLM 模型"
        # Instance info
        S_DEPLOY_COMPLETE="新实例部署完成！"
        S_INSTANCE_INFO_TITLE="OpenClaw 实例信息"
        S_CONTAINER_INFO="🐳 容器信息:"
        S_CONTAINER_NAME_LABEL="   容器名称："
        S_STATUS_LABEL="   状态："
        S_WEB_ACCESS="🌐 Web 访问:"
        S_ADDRESS_LABEL="   地址："
        S_CONTROL_PANEL_LABEL="   控制面板："
        S_DATA_DIR_SECTION="📂 数据目录:"
        S_PATH_LABEL="   路径："
        S_CONFIG_FILE_LABEL="   配置文件："
        S_WORKSPACE_LABEL="   工作空间："
        S_QUICK_CMDS="⚡ 快速命令:"
        S_ENTER_CONTAINER_CMD="   进入容器："
        S_VIEW_LOGS_CMD="   查看日志："
        S_STOP_CMD="   停止："
        S_START_CMD="   启动："
        # Container shell menu
        S_SHELL_TITLE="进入容器进行高级操作"
        S_NO_RUNNING_CONTAINERS="没有运行中的 OpenClaw 容器"
        S_AVAILABLE_CONTAINERS="可用的 OpenClaw 容器:"
        S_GO_BACK="0) ← 返回"
        S_SELECT_CONTAINER="请选择容器"
        S_CONTAINER_SUBMENU_PREFIX="进入容器:"
        S_SHELL_OPT_1="1. 🚀 运行 OpenClaw onboard（推荐）"
        S_SHELL_OPT_2="2. 🔧 运行特定的 OpenClaw 命令"
        S_SHELL_OPT_3="3. 💻 进入容器 Shell"
        S_SHELL_OPT_4="4. 📜 查看日志"
        S_SHELL_OPT_5="5. ⬅️  返回"
        S_STARTING_ONBOARD="启动 OpenClaw onboard 安装流程..."
        S_ENTER_CMD="请输入要运行的命令"
        S_RUNNING_CMD="运行命令:"
        S_ENTERING_SHELL="进入容器 Shell (输入 'exit' 退出)"
        S_VIEWING_LOGS="查看容器日志 (按 Ctrl+C 退出)"
        # Manage menu
        S_MANAGE_TITLE="管理现有 OpenClaw 实例"
        S_NO_CONTAINERS="没有 OpenClaw 容器"
        S_INSTANCE_LIST="OpenClaw 实例列表:"
        S_SELECT_INSTANCE="请选择实例"
        S_MANAGE_INSTANCE_PREFIX="管理实例:"
        S_MANAGE_OPT_1="1. ✅ 启动"
        S_MANAGE_OPT_2="2. ❌ 停止"
        S_MANAGE_OPT_3="3. 🔄 重启"
        S_MANAGE_OPT_4="4. 📊 查看状态"
        S_MANAGE_OPT_5="5. 📜 查看日志"
        S_MANAGE_OPT_6="6. 🗑️  删除"
        S_MANAGE_OPT_7="7. ⬅️  返回"
        S_ACTION_STARTING="启动"
        S_ACTION_STOPPING="停止"
        S_ACTION_RESTARTING="重启"
        S_ACTION_DELETING="删除"
        S_CONTAINER_STARTED_MSG="容器已启动"
        S_CONTAINER_STOPPED_MSG="容器已停止"
        S_CONTAINER_RESTARTED_MSG="容器已重启"
        S_CONTAINER_DELETED_MSG="容器已删除"
        S_CONFIRM_DELETE_FMT="确定要删除 %s 吗?"
        # Troubleshoot menu
        S_TROUBLESHOOT_TITLE="故障诊断和修复"
        S_DIAG_OPT_1="1. 🔍 系统诊断"
        S_DIAG_OPT_2="2. 🐳 Docker 诊断"
        S_DIAG_OPT_3="3. 📊 查看所有容器"
        S_DIAG_OPT_4="4. 🔧 自动修复"
        S_DIAG_OPT_5="5. ⬅️  返回"
        S_RUNNING_SYS_DIAG="系统诊断..."
        S_DOCKER_INSTALL_CHECK="Docker 安装："
        S_DOCKER_DAEMON_CHECK="Docker daemon："
        S_NODEJS_CHECK="Node.js："
        S_NODE_NOT_ON_HOST_SHORT="未在宿主机安装（Docker 容器内会自动安装）"
        S_FIX_OPT_1="1. 重启所有 OpenClaw 容器"
        S_FIX_OPT_2="2. 清理未使用的 Docker 资源"
        S_FIX_OPT_3="3. 重新拉取最新镜像"
        S_FIX_OPT_4="4. ⬅️  返回"
        S_SELECT_FIX="请选择修复操作"
        S_ALL_RESTARTED="所有容器已重启"
        S_CLEANING_DOCKER="清理 Docker 资源..."
        S_CLEAN_DONE="清理完成"
        S_PULLING_IMAGE="重新拉取 OpenClaw 镜像..."
        S_IMAGE_UPDATED="镜像已更新"
        # Help menu
        S_HELP_TITLE="帮助和文档"
        S_HELP_DOCS_HEADER="📚 OpenClaw 官方文档:"
        S_HELP_QUICKSTART="📖 快速开始:"
        S_HELP_STEP1="1️⃣  创建 OpenClaw 实例"
        S_HELP_STEP1_DESC="   选择菜单: 1 → 输入配置 → 自动部署"
        S_HELP_STEP2="2️⃣  进入容器运行 onboard 安装向导"
        S_HELP_STEP2_DESC="   选择菜单: 3 → 选择容器 → 选择 1（运行 onboard）"
        S_HELP_STEP2_DESC2="   Onboard 会自动引导你完成所有配置"
        S_HELP_STEP3="3️⃣  访问 Web UI"
        S_HELP_STEP3_DESC="   打开浏览器，使用你创建实例时指定的端口"
        S_HELP_STEP3_DESC2="   例如：http://localhost:18789（默认端口）"
        S_HELP_STEP3_DESC3="   实际端口取决于你的配置，见下方'查看实例信息'"
        S_HELP_INSTANCE_INFO="🔍 查看实例信息:"
        S_HELP_INSTANCE_INFO_DESC="   选择菜单: 2 → 选择实例"
        S_HELP_INSTANCE_INFO_DESC2="   显示该实例的实际端口和访问地址"
        S_HELP_ONBOARD_FLOW="🔧 Onboard 安装流程:"
        S_HELP_ONBOARD_1="   1️⃣  Gateway 配置（端口、认证等）"
        S_HELP_ONBOARD_2="   2️⃣  工作空间配置"
        S_HELP_ONBOARD_3="   3️⃣  LLM 模型配置（OpenAI/Claude/Gemini 等）"
        S_HELP_ONBOARD_4="   4️⃣  通讯频道配置（WhatsApp/Telegram/Slack 等）"
        S_HELP_ONBOARD_5="   5️⃣  技能和插件配置"
        S_HELP_MULTI="📊 管理多实例:"
        S_HELP_MULTI_DESC="   创建多个实例（如生产/测试/开发）："
        S_HELP_MULTI_EX1="   • 第一次：菜单 1 → 实例名: openclaw-prod → 端口: 18789"
        S_HELP_MULTI_EX2="   • 第二次：菜单 1 → 实例名: openclaw-test → 端口: 18790"
        S_HELP_MULTI_EX3="   • 第三次：菜单 1 → 实例名: openclaw-dev → 端口: 18791"
        S_HELP_MULTI_VIEW="   查看所有实例与对应端口："
        S_HELP_MULTI_VIEW_DESC="   菜单 2 → 会显示每个实例及其端口"
        S_HELP_CMDS="⚡ 常用命令:"
        S_HELP_CMDS_DESC="   在菜单 3 中选择容器后，可以运行："
        S_HELP_CMD1="   • openclaw onboard              - 启动交互式安装"
        S_HELP_CMD2="   • openclaw gateway --port 18789 - 启动 Gateway"
        S_HELP_CMD3="   • openclaw doctor               - 诊断问题"
        S_HELP_CMD4='   • openclaw agent "Hello"        - 发送消息给 AI'
        S_HELP_SUPPORT="📞 技术支持:"
    else
        # ---- English ----
        S_INVALID_YN="Please enter y or n"
        S_PRESS_ENTER="Press Enter to continue"
        S_PRESS_ENTER_BACK="Press Enter to return"
        S_INVALID_CHOICE="Invalid choice"
        S_YES_NO_SUFFIX="(y/n)"
        S_DOCKER_NOT_INSTALLED="Docker is not installed"
        S_DOCKER_INSTALLED="Docker installed:"
        S_DOCKER_NOT_RUNNING="Docker daemon is not running"
        S_DOCKER_RUNNING="Docker daemon is running"
        S_NODE_NOT_ON_HOST="Node.js not found on host (auto-installed in container)"
        S_NODE_INSTALLED="Node.js installed:"
        S_MAIN_MENU="Main Menu"
        S_MENU_1="1. 🚀 Create New OpenClaw  (Docker + Full Install)"
        S_MENU_2="2. 📋 Manage Existing Instances"
        S_MENU_3="3. 🔧 Enter Container  (Advanced)"
        S_MENU_4="4. 🏥 Diagnostics & Repair"
        S_MENU_5="5. 📚 Help & Documentation"
        S_MENU_6="6. ❌ Exit"
        S_SELECT_OP="Select option"
        S_GOODBYE="Goodbye!"
        S_DEPLOY_TITLE="Create New OpenClaw"
        S_DOCKER_REQUIRED="Please install and start Docker first"
        S_CONFIGURE_INSTANCE="Configure new instance:"
        S_INSTANCE_NAME_PROMPT="Instance name"
        S_PORT_PROMPT="Access port"
        S_DATA_DIR_PROMPT="Data directory"
        S_INSTANCE_CONFIG="Instance configuration:"
        S_NAME_LABEL="  Name:          "
        S_PORT_LABEL="  Port:          "
        S_DATA_DIR_LABEL="  Data directory:"
        S_CONFIRM_CREATE="Confirm creating this instance?"
        S_CREATING_DIR="Creating project directory..."
        S_DIR_CREATED="Directory created:"
        S_STARTING_CONTAINER="Starting OpenClaw Docker container..."
        S_CONTAINER_STARTED="Docker container started"
        S_WAITING_CONTAINER="Waiting for container to be ready..."
        S_WAITED_LABEL="Waited:"
        S_OPENCLAW_READY="OpenClaw is ready!"
        S_NEXT_STEPS="📋 Next steps:"
        S_STEP1="1️⃣  Launch OpenClaw onboard installation"
        S_STEP1_DESC="   Select menu: 3 → Enter container → Run onboard"
        S_STEP2="2️⃣  Or access the Web UI directly"
        S_STEP2_URL="   Open browser:"
        S_STEP3="3️⃣  Complete onboard setup"
        S_STEP3_GW="   - Configure Gateway"
        S_STEP3_WS="   - Configure workspace"
        S_STEP3_CH="   - Configure channels (WhatsApp/Telegram/Slack, etc.)"
        S_STEP3_LLM="   - Configure LLM model"
        S_DEPLOY_COMPLETE="New instance deployed successfully!"
        S_INSTANCE_INFO_TITLE="OpenClaw Instance Info"
        S_CONTAINER_INFO="🐳 Container:"
        S_CONTAINER_NAME_LABEL="   Name:          "
        S_STATUS_LABEL="   Status:        "
        S_WEB_ACCESS="🌐 Web access:"
        S_ADDRESS_LABEL="   URL:           "
        S_CONTROL_PANEL_LABEL="   Control panel: "
        S_DATA_DIR_SECTION="📂 Data directory:"
        S_PATH_LABEL="   Path:          "
        S_CONFIG_FILE_LABEL="   Config file:   "
        S_WORKSPACE_LABEL="   Workspace:     "
        S_QUICK_CMDS="⚡ Quick commands:"
        S_ENTER_CONTAINER_CMD="   Enter container:"
        S_VIEW_LOGS_CMD="   View logs:      "
        S_STOP_CMD="   Stop:           "
        S_START_CMD="   Start:          "
        S_SHELL_TITLE="Enter Container  (Advanced)"
        S_NO_RUNNING_CONTAINERS="No running OpenClaw containers"
        S_AVAILABLE_CONTAINERS="Available OpenClaw containers:"
        S_GO_BACK="0) ← Back"
        S_SELECT_CONTAINER="Select container"
        S_CONTAINER_SUBMENU_PREFIX="Container:"
        S_SHELL_OPT_1="1. 🚀 Run OpenClaw onboard  (recommended)"
        S_SHELL_OPT_2="2. 🔧 Run a custom command"
        S_SHELL_OPT_3="3. 💻 Open container shell"
        S_SHELL_OPT_4="4. 📜 View logs"
        S_SHELL_OPT_5="5. ⬅️  Back"
        S_STARTING_ONBOARD="Launching OpenClaw onboard..."
        S_ENTER_CMD="Enter command to run"
        S_RUNNING_CMD="Running command:"
        S_ENTERING_SHELL="Entering container shell (type 'exit' to quit)"
        S_VIEWING_LOGS="Viewing logs (press Ctrl+C to quit)"
        S_MANAGE_TITLE="Manage Existing Instances"
        S_NO_CONTAINERS="No OpenClaw containers found"
        S_INSTANCE_LIST="OpenClaw instance list:"
        S_SELECT_INSTANCE="Select instance"
        S_MANAGE_INSTANCE_PREFIX="Manage instance:"
        S_MANAGE_OPT_1="1. ✅ Start"
        S_MANAGE_OPT_2="2. ❌ Stop"
        S_MANAGE_OPT_3="3. 🔄 Restart"
        S_MANAGE_OPT_4="4. 📊 View status"
        S_MANAGE_OPT_5="5. 📜 View logs"
        S_MANAGE_OPT_6="6. 🗑️  Delete"
        S_MANAGE_OPT_7="7. ⬅️  Back"
        S_ACTION_STARTING="Starting"
        S_ACTION_STOPPING="Stopping"
        S_ACTION_RESTARTING="Restarting"
        S_ACTION_DELETING="Deleting"
        S_CONTAINER_STARTED_MSG="Container started"
        S_CONTAINER_STOPPED_MSG="Container stopped"
        S_CONTAINER_RESTARTED_MSG="Container restarted"
        S_CONTAINER_DELETED_MSG="Container deleted"
        S_CONFIRM_DELETE_FMT="Are you sure you want to delete %s?"
        S_TROUBLESHOOT_TITLE="Diagnostics & Repair"
        S_DIAG_OPT_1="1. 🔍 System diagnostics"
        S_DIAG_OPT_2="2. 🐳 Docker diagnostics"
        S_DIAG_OPT_3="3. 📊 View all containers"
        S_DIAG_OPT_4="4. 🔧 Auto-fix"
        S_DIAG_OPT_5="5. ⬅️  Back"
        S_RUNNING_SYS_DIAG="System diagnostics..."
        S_DOCKER_INSTALL_CHECK="Docker installation:"
        S_DOCKER_DAEMON_CHECK="Docker daemon:     "
        S_NODEJS_CHECK="Node.js:           "
        S_NODE_NOT_ON_HOST_SHORT="Not on host (auto-installed in Docker container)"
        S_FIX_OPT_1="1. Restart all OpenClaw containers"
        S_FIX_OPT_2="2. Clean up unused Docker resources"
        S_FIX_OPT_3="3. Pull latest image"
        S_FIX_OPT_4="4. ⬅️  Back"
        S_SELECT_FIX="Select fix operation"
        S_ALL_RESTARTED="All containers restarted"
        S_CLEANING_DOCKER="Cleaning up Docker resources..."
        S_CLEAN_DONE="Cleanup complete"
        S_PULLING_IMAGE="Pulling latest OpenClaw image..."
        S_IMAGE_UPDATED="Image updated"
        S_HELP_TITLE="Help & Documentation"
        S_HELP_DOCS_HEADER="📚 Official OpenClaw documentation:"
        S_HELP_QUICKSTART="📖 Quick start:"
        S_HELP_STEP1="1️⃣  Create an OpenClaw instance"
        S_HELP_STEP1_DESC="   Select menu 1 → enter config → auto deploy"
        S_HELP_STEP2="2️⃣  Run the onboard wizard inside the container"
        S_HELP_STEP2_DESC="   Select menu: 3 → choose container → select 1 (run onboard)"
        S_HELP_STEP2_DESC2="   Onboard guides you through the full setup automatically"
        S_HELP_STEP3="3️⃣  Access the Web UI"
        S_HELP_STEP3_DESC="   Open your browser and use the port you specified"
        S_HELP_STEP3_DESC2="   e.g. http://localhost:18789 (default port)"
        S_HELP_STEP3_DESC3="   Actual port depends on your config — see 'View instance info'"
        S_HELP_INSTANCE_INFO="🔍 View instance info:"
        S_HELP_INSTANCE_INFO_DESC="   Select menu 2 → choose instance"
        S_HELP_INSTANCE_INFO_DESC2="   Shows actual port and access URL for that instance"
        S_HELP_ONBOARD_FLOW="🔧 Onboard setup steps:"
        S_HELP_ONBOARD_1="   1️⃣  Gateway config (port, auth, etc.)"
        S_HELP_ONBOARD_2="   2️⃣  Workspace setup"
        S_HELP_ONBOARD_3="   3️⃣  LLM model (OpenAI / Claude / Gemini, etc.)"
        S_HELP_ONBOARD_4="   4️⃣  Channels (WhatsApp / Telegram / Slack, etc.)"
        S_HELP_ONBOARD_5="   5️⃣  Skills & plugins"
        S_HELP_MULTI="📊 Multiple instances:"
        S_HELP_MULTI_DESC="   Create separate instances for prod / test / dev:"
        S_HELP_MULTI_EX1="   • Run 1: menu 1 → name: openclaw-prod → port: 18789"
        S_HELP_MULTI_EX2="   • Run 2: menu 1 → name: openclaw-test → port: 18790"
        S_HELP_MULTI_EX3="   • Run 3: menu 1 → name: openclaw-dev  → port: 18791"
        S_HELP_MULTI_VIEW="   View all instances and their ports:"
        S_HELP_MULTI_VIEW_DESC="   Menu 2 → lists each instance and its port"
        S_HELP_CMDS="⚡ Common commands:"
        S_HELP_CMDS_DESC="   After selecting a container in menu 3, you can run:"
        S_HELP_CMD1="   • openclaw onboard              - interactive setup"
        S_HELP_CMD2="   • openclaw gateway --port 18789 - start Gateway"
        S_HELP_CMD3="   • openclaw doctor               - diagnose issues"
        S_HELP_CMD4='   • openclaw agent "Hello"        - send message to AI'
        S_HELP_SUPPORT="📞 Support:"
    fi
}

# ==================== Utility Functions ====================

clear_screen() {
    clear
}

print_header() {
    clear_screen
    echo -e "${BLUE}"
    if [ "$LANG_CHOICE" = "zh" ]; then
        cat << "EOF"
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
EOF
    else
        cat << "EOF"
╔════════════════════════════════════════════════╗
║                                                ║
║   OpenClaw Interactive Setup Tool v1.0         ║
║   Official onboard workflow integrated         ║
║                                                ║
║   • One-click Docker container creation        ║
║   • Automated OpenClaw onboard flow            ║
║   • Interactive config & management            ║
║   • Lark/Feishu integration wizard             ║
║   • Built-in diagnostics & repair              ║
║                                                ║
╚════════════════════════════════════════════════╝
EOF
    fi
    echo -e "${NC}"
}

print_menu() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
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

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

info() {
    echo -e "${BLUE}[i]${NC} $1"
}

read_input() {
    local prompt="$1"
    local default="$2"
    local input

    if [ -z "$default" ]; then
        read -p "$(echo -e ${CYAN}$prompt${NC}): " input
    else
        read -p "$(echo -e ${CYAN}$prompt${NC}) [$default]: " input
        input="${input:-$default}"
    fi

    echo "$input"
}

yes_no_prompt() {
    local prompt="$1"
    local response

    while true; do
        response=$(read_input "$prompt $S_YES_NO_SUFFIX" "y")
        case "$response" in
            [yY]|[yY][eE][sS]) return 0 ;;
            [nN]|[nN][oO]) return 1 ;;
            *) echo -e "${RED}${S_INVALID_YN}${NC}" ;;
        esac
    done
}

# ==================== Check Functions ====================

check_docker() {
    if ! command -v docker &> /dev/null; then
        error "$S_DOCKER_NOT_INSTALLED"
        return 1
    fi

    success "$S_DOCKER_INSTALLED $(docker --version)"

    if ! docker ps > /dev/null 2>&1; then
        error "$S_DOCKER_NOT_RUNNING"
        return 1
    fi

    success "$S_DOCKER_RUNNING"
    return 0
}

check_node() {
    if ! command -v node &> /dev/null; then
        warning "$S_NODE_NOT_ON_HOST"
        return 0
    fi

    success "$S_NODE_INSTALLED $(node --version)"
    return 0
}

# ==================== Main Menu ====================

show_main_menu() {
    print_header
    print_menu "$S_MAIN_MENU"

    echo "$S_MENU_1"
    echo "$S_MENU_2"
    echo "$S_MENU_3"
    echo "$S_MENU_4"
    echo "$S_MENU_5"
    echo "$S_MENU_6"
    echo ""

    local choice=$(read_input "$S_SELECT_OP" "1")

    case "$choice" in
        1) CURRENT_MENU="deploy_with_onboard" ;;
        2) CURRENT_MENU="manage" ;;
        3) CURRENT_MENU="container_shell" ;;
        4) CURRENT_MENU="troubleshoot" ;;
        5) CURRENT_MENU="help" ;;
        6) echo ""; echo "$S_GOODBYE"; exit 0 ;;
        *)
            error "$S_INVALID_CHOICE"
            sleep 1
            CURRENT_MENU="main"
            ;;
    esac
}

# ==================== Deploy + Onboard Menu ====================

show_deploy_with_onboard_menu() {
    print_header
    print_menu "$S_DEPLOY_TITLE"

    if ! check_docker; then
        warning "$S_DOCKER_REQUIRED"
        sleep 2
        CURRENT_MENU="main"
        return
    fi

    check_node

    echo "$S_CONFIGURE_INSTANCE"
    echo ""

    local instance_name=$(read_input "$S_INSTANCE_NAME_PROMPT" "openclaw-gateway")
    local port=$(read_input "$S_PORT_PROMPT" "18789")
    local data_path=$(read_input "$S_DATA_DIR_PROMPT" "$BASE_PATH/$instance_name")

    echo ""
    echo "$S_INSTANCE_CONFIG"
    echo "${S_NAME_LABEL}$instance_name"
    echo "${S_PORT_LABEL}$port"
    echo "${S_DATA_DIR_LABEL}$data_path"
    echo ""

    if ! yes_no_prompt "$S_CONFIRM_CREATE"; then
        CURRENT_MENU="main"
        return
    fi

    deploy_openclaw_with_onboard "$instance_name" "$port" "$data_path"
}

deploy_openclaw_with_onboard() {
    local container_name=$1
    local port=$2
    local data_path=$3

    echo ""
    step "$S_CREATING_DIR"
    mkdir -p "$data_path"
    success "$S_DIR_CREATED $data_path"

    echo ""
    step "$S_STARTING_CONTAINER"

    # Remove old container with same name if exists
    docker rm -f "$container_name" 2>/dev/null || true

    # Start new container
    docker run -d \
        --name "$container_name" \
        --restart unless-stopped \
        --label "openclaw=true" \
        -v "$data_path:/home/node/.openclaw" \
        -v "$data_path/workspace:/workspace" \
        -p "$port:18789" \
        -e "NODE_ENV=production" \
        ghcr.io/openclaw/openclaw:latest

    success "$S_CONTAINER_STARTED"

    echo ""
    step "$S_WAITING_CONTAINER"

    WAITED=0
    MAX_WAIT=60

    while [ $WAITED -lt $MAX_WAIT ]; do
        if docker logs "$container_name" 2>&1 | grep -q "ready\|listening"; then
            success "$S_OPENCLAW_READY"
            break
        fi
        sleep 5
        WAITED=$((WAITED + 5))
        echo -ne "\r  $S_WAITED_LABEL ${WAITED}s"
    done

    echo ""
    echo ""

    show_openclaw_setup_info "$container_name" "$port" "$data_path"

    echo ""
    echo "$S_NEXT_STEPS"
    echo ""
    echo "$S_STEP1"
    echo "$S_STEP1_DESC"
    echo ""
    echo "$S_STEP2"
    echo "$S_STEP2_URL http://localhost:$port"
    echo ""
    echo "$S_STEP3"
    echo "$S_STEP3_GW"
    echo "$S_STEP3_WS"
    echo "$S_STEP3_CH"
    echo "$S_STEP3_LLM"
    echo ""

    read_input "$S_PRESS_ENTER"
    CURRENT_MENU="main"
}

show_openclaw_setup_info() {
    local container_name=$1
    local port=$2
    local data_path=$3

    success "$S_DEPLOY_COMPLETE"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $S_INSTANCE_INFO_TITLE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "$S_CONTAINER_INFO"
    echo "${S_CONTAINER_NAME_LABEL}$container_name"
    echo "${S_STATUS_LABEL}$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null || echo 'running')"
    echo ""
    echo "$S_WEB_ACCESS"
    echo "${S_ADDRESS_LABEL}http://localhost:$port"
    echo "${S_CONTROL_PANEL_LABEL}http://localhost:$port/control"
    echo ""
    echo "$S_DATA_DIR_SECTION"
    echo "${S_PATH_LABEL}$data_path"
    echo "${S_CONFIG_FILE_LABEL}$data_path/openclaw.json"
    echo "${S_WORKSPACE_LABEL}$data_path/workspace"
    echo ""
    echo "$S_QUICK_CMDS"
    echo "${S_ENTER_CONTAINER_CMD} docker exec -it $container_name bash"
    echo "${S_VIEW_LOGS_CMD} docker logs -f $container_name"
    echo "${S_STOP_CMD} docker stop $container_name"
    echo "${S_START_CMD} docker start $container_name"
    echo ""
}

# ==================== Container Shell Menu ====================

show_container_shell_menu() {
    print_header
    print_menu "$S_SHELL_TITLE"

    local containers=($(docker ps --filter "label=openclaw=true" --format "{{.Names}}" 2>/dev/null))

    if [ ${#containers[@]} -eq 0 ]; then
        error "$S_NO_RUNNING_CONTAINERS"
        echo ""
        read_input "$S_PRESS_ENTER_BACK"
        CURRENT_MENU="main"
        return
    fi

    echo "$S_AVAILABLE_CONTAINERS"
    echo ""

    local i=0
    for container in "${containers[@]}"; do
        i=$((i + 1))
        echo "$i) $container"
    done

    echo ""
    echo "$S_GO_BACK"
    echo ""

    local choice=$(read_input "$S_SELECT_CONTAINER" "1")

    if [ "$choice" = "0" ]; then
        CURRENT_MENU="main"
        return
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#containers[@]} ]; then
        error "$S_INVALID_CHOICE"
        sleep 1
        CURRENT_MENU="container_shell"
        return
    fi

    local selected_container="${containers[$((choice - 1))]}"

    echo ""
    print_menu "$S_CONTAINER_SUBMENU_PREFIX $selected_container"
    echo ""
    echo "$S_SHELL_OPT_1"
    echo "$S_SHELL_OPT_2"
    echo "$S_SHELL_OPT_3"
    echo "$S_SHELL_OPT_4"
    echo "$S_SHELL_OPT_5"
    echo ""

    local cmd_choice=$(read_input "$S_SELECT_OP" "1")

    case "$cmd_choice" in
        1)
            echo ""
            step "$S_STARTING_ONBOARD"
            echo ""
            docker exec -it "$selected_container" npx openclaw@latest onboard --install-daemon 2>&1 || true
            ;;
        2)
            echo ""
            local custom_cmd=$(read_input "$S_ENTER_CMD" "openclaw doctor")
            echo ""
            step "$S_RUNNING_CMD $custom_cmd"
            echo ""
            docker exec -it "$selected_container" bash -c "$custom_cmd" 2>&1 || true
            ;;
        3)
            echo ""
            info "$S_ENTERING_SHELL"
            echo ""
            docker exec -it "$selected_container" bash
            ;;
        4)
            echo ""
            info "$S_VIEWING_LOGS"
            echo ""
            docker logs -f "$selected_container"
            ;;
        5)
            CURRENT_MENU="main"
            return
            ;;
    esac

    echo ""
    read_input "$S_PRESS_ENTER_BACK"
    CURRENT_MENU="main"
}

# ==================== Manage Menu ====================

show_manage_menu() {
    print_header
    print_menu "$S_MANAGE_TITLE"

    local containers=($(docker ps -a --filter "label=openclaw=true" --format "{{.Names}}" 2>/dev/null))

    if [ ${#containers[@]} -eq 0 ]; then
        error "$S_NO_CONTAINERS"
        echo ""
        read_input "$S_PRESS_ENTER_BACK"
        CURRENT_MENU="main"
        return
    fi

    echo "$S_INSTANCE_LIST"
    echo ""

    local i=0
    for container in "${containers[@]}"; do
        i=$((i + 1))
        local status=$(docker ps -a --filter "name=$container" --format "{{.Status}}" 2>/dev/null)
        echo "$i) $container - $status"
    done

    echo ""
    echo "$S_GO_BACK"
    echo ""

    local choice=$(read_input "$S_SELECT_INSTANCE" "1")

    if [ "$choice" = "0" ]; then
        CURRENT_MENU="main"
        return
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#containers[@]} ]; then
        error "$S_INVALID_CHOICE"
        sleep 1
        CURRENT_MENU="manage"
        return
    fi

    local selected_container="${containers[$((choice - 1))]}"

    echo ""
    echo "$S_MANAGE_INSTANCE_PREFIX $selected_container"
    echo ""
    echo "$S_MANAGE_OPT_1"
    echo "$S_MANAGE_OPT_2"
    echo "$S_MANAGE_OPT_3"
    echo "$S_MANAGE_OPT_4"
    echo "$S_MANAGE_OPT_5"
    echo "$S_MANAGE_OPT_6"
    echo "$S_MANAGE_OPT_7"
    echo ""

    local action=$(read_input "$S_SELECT_OP" "1")

    case "$action" in
        1)
            step "$S_ACTION_STARTING $selected_container..."
            docker start "$selected_container" 2>/dev/null || true
            success "$S_CONTAINER_STARTED_MSG"
            ;;
        2)
            step "$S_ACTION_STOPPING $selected_container..."
            docker stop "$selected_container" 2>/dev/null || true
            success "$S_CONTAINER_STOPPED_MSG"
            ;;
        3)
            step "$S_ACTION_RESTARTING $selected_container..."
            docker restart "$selected_container" 2>/dev/null || true
            success "$S_CONTAINER_RESTARTED_MSG"
            ;;
        4)
            echo ""
            docker ps -a --filter "name=$selected_container" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || true
            ;;
        5)
            echo ""
            docker logs -f "$selected_container" 2>/dev/null || true
            ;;
        6)
            local confirm_msg
            # shellcheck disable=SC2059
            confirm_msg="$(printf "$S_CONFIRM_DELETE_FMT" "$selected_container")"
            if yes_no_prompt "$confirm_msg"; then
                step "$S_ACTION_DELETING $selected_container..."
                docker stop "$selected_container" 2>/dev/null || true
                docker rm "$selected_container" 2>/dev/null || true
                success "$S_CONTAINER_DELETED_MSG"
            fi
            ;;
        7)
            CURRENT_MENU="main"
            return
            ;;
    esac

    echo ""
    read_input "$S_PRESS_ENTER_BACK"
    CURRENT_MENU="main"
}

# ==================== Troubleshoot Menu ====================

show_troubleshoot_menu() {
    print_header
    print_menu "$S_TROUBLESHOOT_TITLE"

    echo "$S_DIAG_OPT_1"
    echo "$S_DIAG_OPT_2"
    echo "$S_DIAG_OPT_3"
    echo "$S_DIAG_OPT_4"
    echo "$S_DIAG_OPT_5"
    echo ""

    local choice=$(read_input "$S_SELECT_OP" "1")

    case "$choice" in
        1)
            echo ""
            step "$S_RUNNING_SYS_DIAG"
            echo ""
            echo "$S_DOCKER_INSTALL_CHECK"
            command -v docker &> /dev/null && success "$S_INSTALLED" || error "$S_NOT_INSTALLED"
            echo ""
            echo "$S_DOCKER_DAEMON_CHECK"
            docker ps > /dev/null 2>&1 && success "$S_RUNNING" || error "$S_NOT_RUNNING"
            echo ""
            echo "$S_NODEJS_CHECK"
            if command -v node &> /dev/null; then
                success "$(node --version)"
            else
                info "$S_NODE_NOT_ON_HOST_SHORT"
            fi
            ;;
        2)
            echo ""
            docker ps -a --filter "label=openclaw=true"
            ;;
        3)
            echo ""
            docker ps -a
            ;;
        4)
            echo ""
            echo "$S_FIX_OPT_1"
            echo "$S_FIX_OPT_2"
            echo "$S_FIX_OPT_3"
            echo "$S_FIX_OPT_4"
            echo ""

            local fix_choice=$(read_input "$S_SELECT_FIX" "1")

            case "$fix_choice" in
                1)
                    docker ps -a --filter "label=openclaw=true" --format "{{.Names}}" | while read container; do
                        step "$S_ACTION_RESTARTING $container..."
                        docker restart "$container" 2>/dev/null || true
                    done
                    success "$S_ALL_RESTARTED"
                    ;;
                2)
                    step "$S_CLEANING_DOCKER"
                    docker system prune -f > /dev/null 2>&1
                    success "$S_CLEAN_DONE"
                    ;;
                3)
                    step "$S_PULLING_IMAGE"
                    docker pull ghcr.io/openclaw/openclaw:latest
                    success "$S_IMAGE_UPDATED"
                    ;;
                4)
                    CURRENT_MENU="troubleshoot"
                    return
                    ;;
            esac
            ;;
        5)
            CURRENT_MENU="main"
            return
            ;;
    esac

    echo ""
    read_input "$S_PRESS_ENTER_BACK"
    CURRENT_MENU="main"
}

# ==================== Help Menu ====================

show_help_menu() {
    print_header
    print_menu "$S_HELP_TITLE"

    echo "$S_HELP_DOCS_HEADER"
    echo "   Website: https://openclaw.ai"
    echo "   Docs:    https://docs.openclaw.ai"
    echo "   GitHub:  https://github.com/openclaw/openclaw"
    echo ""
    echo "$S_HELP_QUICKSTART"
    echo ""
    echo "$S_HELP_STEP1"
    echo "$S_HELP_STEP1_DESC"
    echo ""
    echo "$S_HELP_STEP2"
    echo "$S_HELP_STEP2_DESC"
    echo "$S_HELP_STEP2_DESC2"
    echo ""
    echo "$S_HELP_STEP3"
    echo "$S_HELP_STEP3_DESC"
    echo "$S_HELP_STEP3_DESC2"
    echo "$S_HELP_STEP3_DESC3"
    echo ""
    echo "$S_HELP_INSTANCE_INFO"
    echo "$S_HELP_INSTANCE_INFO_DESC"
    echo "$S_HELP_INSTANCE_INFO_DESC2"
    echo ""
    echo "$S_HELP_ONBOARD_FLOW"
    echo "$S_HELP_ONBOARD_1"
    echo "$S_HELP_ONBOARD_2"
    echo "$S_HELP_ONBOARD_3"
    echo "$S_HELP_ONBOARD_4"
    echo "$S_HELP_ONBOARD_5"
    echo ""
    echo "$S_HELP_MULTI"
    echo "$S_HELP_MULTI_DESC"
    echo "$S_HELP_MULTI_EX1"
    echo "$S_HELP_MULTI_EX2"
    echo "$S_HELP_MULTI_EX3"
    echo ""
    echo "$S_HELP_MULTI_VIEW"
    echo "$S_HELP_MULTI_VIEW_DESC"
    echo ""
    echo "$S_HELP_CMDS"
    echo "$S_HELP_CMDS_DESC"
    echo "$S_HELP_CMD1"
    echo "$S_HELP_CMD2"
    echo "$S_HELP_CMD3"
    echo "$S_HELP_CMD4"
    echo ""
    echo "$S_HELP_SUPPORT"
    echo "   Discord: https://discord.gg/clawd"
    echo "   Issues:  https://github.com/openclaw/openclaw/issues"
    echo "   Docs:    https://docs.openclaw.ai"
    echo ""

    read_input "$S_PRESS_ENTER_BACK"
    CURRENT_MENU="main"
}

# ==================== Main Loop ====================

main_loop() {
    while true; do
        case "$CURRENT_MENU" in
            main) show_main_menu ;;
            deploy_with_onboard) show_deploy_with_onboard_menu ;;
            manage) show_manage_menu ;;
            container_shell) show_container_shell_menu ;;
            troubleshoot) show_troubleshoot_menu ;;
            help) show_help_menu ;;
        esac
    done
}

# ==================== Entry Point ====================

select_language
main_loop
