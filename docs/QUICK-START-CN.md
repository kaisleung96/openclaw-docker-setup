# 快速开始指南（中文）

## 📖 5 分钟快速上手 OpenClaw Docker Setup

### 1️⃣ 前置要求

在开始之前，请确保你已安装：

- **Docker** - [下载 Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Git** - [下载 Git](https://git-scm.com/downloads)
- **Bash** - macOS 和 Linux 默认包含，Windows 用户需要 WSL2

### 2️⃣ 获取项目

```bash
# 克隆仓库
git clone https://github.com/kaisleung96/openclaw-docker-setup.git

# 进入目录
cd openclaw-docker-setup
```

### 3️⃣ 启动脚本

```bash
bash src/openclaw-docker-setup.sh
```

首先会出现语言选择界面：

```
  ╔════════════════════════════════════════════════╗
  ║       OpenClaw Setup Tool v1.0.0             ║
  ╚════════════════════════════════════════════════╝

  Select language / 选择语言:

  1. English  (default)
  2. 中文

  [1]:
```

输入 `2` 选择中文，然后按 Enter。

你会看到以下菜单：

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

请选择操作 [1]:
```

### 4️⃣ 创建你的第一个实例

选择菜单 **1**（创建新的 OpenClaw）

```
实例名称 (默认: openclaw-gateway): 
# 按 Enter 使用默认名称，或输入你的实例名称

访问端口 (默认: 18789): 
# 按 Enter 使用默认端口，或输入其他端口

数据目录 (默认: ~/openclaw-deployment/openclaw-gateway): 
# 按 Enter 使用默认路径，或输入自定义路径
```

确认后，脚本会自动：
- ✅ 在宿主机创建数据目录（`~/openclaw-deployment/<实例名称>/`）
- ✅ 拉取最新 OpenClaw Docker 镜像
- ✅ 启动容器（绑定数据目录，设置端口映射）
- ✅ 等待 OpenClaw 就绪（最多 60 秒）
- ✅ 显示访问信息

### 5️⃣ 运行 Onboard 安装向导

容器启动后，选择菜单 **3**（进入容器进行高级操作）：

```
进入容器: openclaw-gateway

1. 🚀 运行 OpenClaw onboard（推荐）
2. 🔧 运行特定的 OpenClaw 命令
3. 💻 进入容器 Shell
4. 📜 查看日志
5. ⬅️  返回
```

选择 **1**（运行 OpenClaw onboard），这会在容器内执行：

```bash
npx openclaw@latest onboard --install-daemon
```

**Onboard 配置步骤：**

1. 📍 **Gateway 配置** - 设置端口和认证
2. 📍 **工作空间配置** - 设置 AI 助手的工作环境
3. 📍 **LLM 模型配置** - 选择 AI 模型（OpenAI / Claude / Gemini 等）
4. 📍 **通讯频道配置** - 连接 WhatsApp / Telegram / Slack 等
5. 📍 **技能和插件配置** - 启用需要的技能

### 6️⃣ 访问 OpenClaw

在浏览器中打开：

```
http://localhost:18789
```

控制面板：

```
http://localhost:18789/control
```

🎉 **完成！** 你现在可以开始使用 OpenClaw 了！

---

## 📂 数据存储位置

所有数据存储在宿主机（不使用 Docker Named Volume）：

```
~/openclaw-deployment/openclaw-gateway/
├── openclaw.json       # 配置文件
└── workspace/          # 工作空间目录
```

容器删除后数据依然保留在宿主机目录中。

---

## 📝 常见任务

### 查看所有容器

```bash
docker ps -a --filter "label=openclaw=true"
```

### 查看容器日志

```bash
docker logs -f openclaw-gateway
```

### 进入容器 Shell

```bash
docker exec -it openclaw-gateway bash
```

### 停止容器

```bash
docker stop openclaw-gateway
```

### 启动已停止的容器

```bash
docker start openclaw-gateway
```

### 删除容器

```bash
docker stop openclaw-gateway
docker rm openclaw-gateway
```

---

## 🆘 故障排查

### 问题 1: Docker 未安装

**解决方案：**
```bash
# 检查 Docker 是否安装
docker --version

# 如果未安装，下载安装：
# https://www.docker.com/products/docker-desktop
```

### 问题 2: Docker daemon 未运行

**解决方案：**
- **macOS/Windows**: 打开 Docker Desktop 应用
- **Linux**: 运行 `sudo systemctl start docker`

### 问题 3: 无法访问 http://localhost:18789

**解决方案：**
```bash
# 1. 检查容器是否运行
docker ps --filter "label=openclaw=true"

# 2. 检查端口映射
docker port openclaw-gateway

# 3. 检查容器日志
docker logs openclaw-gateway

# 4. 如果端口已被占用，使用不同的端口创建新实例
bash src/openclaw-docker-setup.sh
# 选择菜单 1，输入不同的端口（如 18790）
```

### 问题 4: onboard 卡住或无响应

**解决方案：**
```bash
# 停止并重启容器
docker restart openclaw-gateway

# 重新运行 onboard
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

---

## 📚 更多帮助

在脚本菜单中：

- 选择菜单 **5** 查看完整帮助
- 选择菜单 **4** 运行诊断检查
- 选择菜单 **2** 管理现有实例

---

## 💡 提示

### 📌 多个实例

你可以创建多个独立的 OpenClaw 实例，只需使用不同的实例名称和端口号：

```bash
# 第一个实例（生产环境）
bash src/openclaw-docker-setup.sh
# 输入：openclaw-prod，端口 18789

# 第二个实例（测试环境）
bash src/openclaw-docker-setup.sh
# 输入：openclaw-test，端口 18790

# 第三个实例（开发环境）
bash src/openclaw-docker-setup.sh
# 输入：openclaw-dev，端口 18791
```

### 📌 自定义数据目录

```bash
# 使用自定义基础目录
OPENCLAW_PATH=/data/openclaw bash src/openclaw-docker-setup.sh
```

---

## 🎯 下一步

- 📖 阅读 [完整使用指南](USAGE-CN.md)
- 🐛 报告问题：[GitHub Issues](https://github.com/kaisleung96/openclaw-docker-setup/issues)
- 💬 加入 Discord：[https://discord.gg/clawd](https://discord.gg/clawd)

---

**祝你使用愉快！有任何问题欢迎提问。** 😊
