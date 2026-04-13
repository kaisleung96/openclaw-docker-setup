# 安装指南（中文）

## 目录

1. [系统要求](#系统要求)
2. [安装 Docker](#安装-docker)
3. [克隆项目](#克隆项目)
4. [验证安装](#验证安装)
5. [故障排查](#故障排查)

---

## 系统要求

### 操作系统

- 🍎 **macOS** 10.15 或更高版本
- 🐧 **Linux** - Ubuntu 18.04+、Debian 10+、CentOS 7+
- 🪟 **Windows** 10/11 + WSL2

### 硬件要求

- 💾 **磁盘空间** - 至少 10GB（用于 Docker 镜像、容器和数据）
- 🧠 **内存** - 至少 4GB（推荐 8GB）
- 🔌 **CPU** - 2 核或以上

### 软件要求

- ✅ **Docker** - 最新版本（必须）
- ✅ **Git** - 用于克隆项目
- ✅ **Bash** - 运行脚本

> **注意：** 不需要在宿主机安装 Node.js，所有 OpenClaw 运行时都在 Docker 容器内。

---

## 安装 Docker

### macOS 安装

**方法 1：使用 Docker Desktop（推荐）**

1. 访问 [Docker 官网](https://www.docker.com/products/docker-desktop)
2. 点击 "Download for Mac"
3. 根据你的 Mac 芯片选择：
   - **Apple Silicon（M1/M2/M3/M4）** - 选择 ARM 版本
   - **Intel** - 选择 Intel 版本
4. 安装并启动 Docker Desktop

**验证安装：**
```bash
docker --version
docker ps
```

**方法 2：使用 Homebrew**

```bash
brew install --cask docker
```

### Windows 安装（WSL2）

**重要：** Windows 需要使用 WSL2（Windows Subsystem for Linux 2）

**步骤 1：启用 WSL2**

```powershell
# 以管理员身份运行 PowerShell
wsl --install

# 如果已安装但需要更新
wsl --update
```

**步骤 2：安装 Docker Desktop**

1. 访问 [Docker 官网](https://www.docker.com/products/docker-desktop)
2. 下载 "Docker Desktop for Windows"
3. 运行安装程序
4. 在安装过程中，确保勾选"Use WSL 2 instead of Hyper-V"

**步骤 3：配置 WSL2 集成**

1. 打开 Docker Desktop
2. 进入 Settings → Resources → WSL Integration
3. 选择你的 Linux 发行版

**验证安装（在 WSL2 中运行）：**
```bash
docker --version
docker ps
```

### Linux 安装

**Ubuntu/Debian：**

```bash
# 更新包列表
sudo apt-get update

# 安装 Docker
sudo apt-get install -y docker.io

# 启动 Docker
sudo systemctl start docker

# 设置开机自启
sudo systemctl enable docker

# （推荐）添加当前用户到 docker 组，避免每次使用 sudo
sudo usermod -aG docker $USER

# 注销后重新登录以应用权限
exit
```

**CentOS/RHEL：**

```bash
# 安装 Docker
sudo yum install -y docker

# 启动 Docker
sudo systemctl start docker

# 设置开机自启
sudo systemctl enable docker

# 添加当前用户到 docker 组
sudo usermod -aG docker $USER
```

**验证安装：**
```bash
docker --version
docker ps
```

---

## 克隆项目

### 使用 HTTPS（推荐新手）

```bash
# 克隆仓库
git clone https://github.com/kaisleung96/openclaw-docker-setup.git

# 进入项目目录
cd openclaw-docker-setup
```

### 使用 SSH（需要配置 SSH 密钥）

```bash
# 克隆仓库
git clone git@github.com:kaisleung96/openclaw-docker-setup.git

# 进入项目目录
cd openclaw-docker-setup
```

### 项目结构

克隆后的目录结构如下：

```
openclaw-docker-setup/
├── README.md                      # 项目说明（英文）
├── USAGE.md                       # 使用指南（英文）
├── CONTRIBUTING.md                # 贡献指南
├── LICENSE                        # MIT 许可证
│
├── src/
│   └── openclaw-docker-setup.sh   # 主脚本（交互式 CLI）
│
└── docs/
    ├── README-CN.md               # 项目说明（中文）
    ├── USAGE-CN.md                # 使用指南（中文）
    ├── QUICK-START-CN.md          # 快速开始（中文）
    ├── INSTALLATION-CN.md         # 安装指南（中文，本文件）
    ├── TROUBLESHOOTING-CN.md      # 故障排查（中文）
    ├── FAQ-CN.md                  # 常见问题（中文）
    ├── DOCUMENTATION-INDEX-CN.md  # 中文文档导航
    └── installation.md            # 安装说明（英文）
```

---

## 验证安装

### 检查 Docker

```bash
# 检查 Docker 版本
docker --version
# 输出示例：Docker version 25.0.0, build abc1234

# 检查 Docker daemon 是否运行
docker ps
# 输出应显示表头（即使没有容器）
```

### 检查 Git

```bash
# 检查 Git 版本
git --version
# 输出示例：git version 2.43.0
```

### 运行脚本验证

```bash
# 进入项目目录
cd openclaw-docker-setup

# 运行脚本
bash src/openclaw-docker-setup.sh

# 应该看到中文交互菜单，说明安装成功！
```

---

## 故障排查

### 问题 1: "command not found: docker"

**原因：** Docker 未安装或未在 PATH 中

**解决方案：**

```bash
# macOS (Homebrew)
brew install --cask docker

# Linux
sudo apt-get install -y docker.io

# 重启终端
exec bash

# 再次验证
docker --version
```

### 问题 2: "permission denied while trying to connect to Docker daemon"

**原因：** 当前用户没有 Docker 权限（Linux）

**解决方案：**

```bash
# 方法 1: 使用 sudo（临时）
sudo bash src/openclaw-docker-setup.sh

# 方法 2: 添加用户到 docker 组（永久）
sudo usermod -aG docker $USER

# 注销并重新登录
exit

# 重新连接后测试
docker ps
```

### 问题 3: "Cannot connect to Docker daemon"

**原因：** Docker daemon 未运行

**解决方案：**

```bash
# macOS/Windows
# 打开 Docker Desktop 应用

# Linux
sudo systemctl start docker

# 验证 Docker 运行中
docker ps
```

### 问题 4: "git: command not found"

**原因：** Git 未安装

**解决方案：**

```bash
# macOS (Homebrew)
brew install git

# Ubuntu/Debian
sudo apt-get install -y git

# CentOS/RHEL
sudo yum install -y git

# Windows
# 下载 https://git-scm.com/download/win
```

### 问题 5: 克隆失败 - 网络连接问题

**解决方案：**

```bash
# 方法 1: 重试
git clone https://github.com/kaisleung96/openclaw-docker-setup.git

# 方法 2: 检查网络
ping github.com

# 方法 3: 手动下载 ZIP
# 访问 https://github.com/kaisleung96/openclaw-docker-setup
# 点击 "Code" → "Download ZIP"
```

### 问题 6: WSL2 相关问题（Windows）

**解决方案：**

```powershell
# 以管理员身份运行 PowerShell

# 更新 WSL
wsl --update

# 如果仍然有问题，重置并重装
wsl --unregister Ubuntu
wsl --install
```

---

## 卸载

### 卸载本项目

```bash
# 停止并删除所有 OpenClaw 容器
docker ps -a --filter "label=openclaw=true" -q | xargs docker rm -f

# 删除项目目录
rm -rf openclaw-docker-setup

# （可选）删除数据目录
rm -rf ~/openclaw-deployment
```

### 卸载 Docker

**macOS:**
```bash
# Docker Desktop
# 1. 打开 Applications 文件夹
# 2. 右键 Docker.app → 移到废纸篓

# Homebrew
brew uninstall --cask docker
```

**Ubuntu/Debian:**
```bash
sudo apt-get remove -y docker.io
sudo apt-get purge -y docker.io
```

**CentOS/RHEL:**
```bash
sudo yum remove -y docker
```

---

## 下一步

安装完成后，查看：

1. 📖 [快速开始指南](QUICK-START-CN.md) - 5 分钟上手
2. 📚 [完整使用指南](USAGE-CN.md) - 详细的功能说明
3. 🚀 运行脚本创建你的第一个实例：`bash src/openclaw-docker-setup.sh`

---

## 获取帮助

- 💬 Discord: [https://discord.gg/clawd](https://discord.gg/clawd)
- 📧 Issues: [GitHub Issues](https://github.com/kaisleung96/openclaw-docker-setup/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/kaisleung96/openclaw-docker-setup/discussions)
- 🌐 OpenClaw 文档: [https://docs.openclaw.ai](https://docs.openclaw.ai)

---

**祝你安装顺利！有问题欢迎提问。** 😊
