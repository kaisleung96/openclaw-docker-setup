# openclaw-docker-setup

🚀 用于在隔离的 Docker 沙箱中运行 OpenClaw 的自动化设置脚本

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/kaisleung96/openclaw-docker-setup?style=flat)](https://github.com/kaisleung96/openclaw-docker-setup)
[![Docker](https://img.shields.io/badge/Docker-Supported-blue?logo=docker)](https://www.docker.com)

[English](../README.md) | **中文**

---

## ✨ 主要功能

- 🐳 **Docker 沙箱设置** - 快速创建隔离的 OpenClaw 容器
- 🔐 **主机隔离优先** - 降低修改本机文件的风险
- 🚀 **官方 Onboard 集成** - 支持 `--install-daemon` 的完整 OpenClaw 设置向导
- ⚙️ **交互式 CLI** - 中文交互菜单，无需手动执行 Docker 命令
- 🏥 **诊断和修复** - 内置故障排查与自动修复工具

---

## 🎯 快速开始

### 前置要求

- Docker 和 Docker daemon 正在运行
- Bash shell

### 三行命令启动

```bash
git clone https://github.com/kaisleung96/openclaw-docker-setup.git
cd openclaw-docker-setup
bash src/openclaw-docker-setup.sh
```

### 然后

```
选择菜单 1 → 输入实例名称和端口 → 等待容器启动
选择菜单 3 → 选择容器 → 选择 1（运行 onboard）
```

在浏览器中打开：`http://localhost:18789`

**完成！** ✅

---

## 📚 完整文档

### 中文文档（推荐中文用户）

- 📖 **[快速开始指南](./QUICK-START-CN.md)** - 5 分钟上手
- 📋 **[完整使用指南](./USAGE-CN.md)** - 详细功能说明
- 🔧 **[安装指南](./INSTALLATION-CN.md)** - 各系统安装步骤
- 🔴 **[故障排查](./TROUBLESHOOTING-CN.md)** - 问题解决方案
- ❓ **[常见问题](./FAQ-CN.md)** - 常见问题解答
- 🗂️ **[文档导航](./DOCUMENTATION-INDEX-CN.md)** - 文档索引和学习路径

### 英文文档

- [Installation Guide](./installation.md)
- [Usage Guide](../USAGE.md)

---

## 🔒 为什么选择 Docker 隔离？

OpenClaw 是一个强大的 AI 助手，可以执行系统命令。通过使用 Docker 容器：

✅ **完全隔离** - OpenClaw 在沙箱中运行  
✅ **数据安全** - 所有数据通过绑定挂载存储在宿主机指定目录  
✅ **系统保护** - 问题只影响容器，不影响主机  
✅ **易于管理** - 可以创建多个独立实例

---

## 🛠️ 菜单选项

运行脚本后，你会看到以下菜单：

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

**菜单说明：**

| 菜单 | 功能 | 说明 |
|------|------|------|
| 1 | 创建新的 OpenClaw | 创建容器 + 数据目录 |
| 2 | 管理现有实例 | 启动/停止/重启/删除 |
| 3 | 进入容器高级操作 | 运行 onboard、自定义命令、Shell、日志 |
| 4 | 故障诊断和修复 | 系统诊断、Docker 诊断、自动修复 |
| 5 | 帮助和文档 | 显示快速开始指南 |
| 6 | 退出 | 退出程序 |

---

## 📂 数据存储

所有数据通过绑定挂载存储在宿主机，**不使用** Docker Named Volume：

```
~/openclaw-deployment/<实例名称>/
├── openclaw.json       # 配置文件
└── workspace/          # 工作空间目录
```

可以通过环境变量覆盖基础目录：

```bash
OPENCLAW_PATH=/your/custom/path bash src/openclaw-docker-setup.sh
```

---

## 💡 常见任务

### 创建新实例

```bash
bash src/openclaw-docker-setup.sh
# 选择菜单 1
# 输入实例名称（默认：openclaw-gateway）和端口（默认：18789）
```

### 运行 onboard 安装向导

```bash
# 方法 1: 通过菜单（推荐）
bash src/openclaw-docker-setup.sh
# 选择菜单 3 → 选择容器 → 选择 1

# 方法 2: 直接运行
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

### 查看容器日志

```bash
docker logs -f openclaw-gateway
```

### 查看所有实例

```bash
docker ps -a --filter "label=openclaw=true"
```

### 停止/启动实例

```bash
docker stop openclaw-gateway
docker start openclaw-gateway
```

---

## 📊 多个实例

你可以创建多个独立的 OpenClaw 实例：

```bash
# 生产环境：名称 openclaw-prod，端口 18789
# 测试环境：名称 openclaw-test，端口 18790
# 开发环境：名称 openclaw-dev，端口 18791
```

每次运行脚本选择菜单 1，输入不同的名称和端口即可。

---

## 🤝 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](../CONTRIBUTING.md)。

## 📄 许可证

MIT 许可证 - 查看 [LICENSE](../LICENSE)

---

## 🌍 相关项目

- [OpenClaw](https://github.com/openclaw/openclaw) - 官方 OpenClaw 项目

---

**立即开始使用 OpenClaw Docker Setup！** 🚀

```bash
git clone https://github.com/kaisleung96/openclaw-docker-setup.git
cd openclaw-docker-setup
bash src/openclaw-docker-setup.sh
```

by kaisleung96
