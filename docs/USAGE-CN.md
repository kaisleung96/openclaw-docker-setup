# 完整使用指南（中文）

## 目录

1. [菜单详解](#菜单详解)
2. [常见任务](#常见任务)
3. [高级用法](#高级用法)
4. [故障排查](#故障排查)
5. [最佳实践](#最佳实践)

---

## 菜单详解

### 菜单 1️⃣：创建新的 OpenClaw

用于创建一个新的 OpenClaw 实例（Docker 容器 + 数据目录）。

**步骤：**
```bash
bash src/openclaw-docker-setup.sh
# 选择 1
```

**需要输入的信息：**

| 提示 | 默认值 | 说明 |
|------|--------|------|
| 实例名称 | `openclaw-gateway` | Docker 容器名称 |
| 访问端口 | `18789` | 宿主机访问端口 |
| 数据目录 | `~/openclaw-deployment/openclaw-gateway` | 宿主机绑定挂载路径 |

**创建后发生的事情：**
1. 在宿主机创建数据目录
2. 停止并删除同名旧容器（如有）
3. 启动新容器（镜像：`ghcr.io/openclaw/openclaw:latest`）
4. 等待容器就绪（最多 60 秒）
5. 显示实例信息和后续步骤

**容器参数：**
```bash
docker run -d \
    --name <实例名称> \
    --restart unless-stopped \
    --label "openclaw=true" \
    -v <数据目录>:/home/node/.openclaw \
    -v <数据目录>/workspace:/workspace \
    -p <端口>:18789 \
    -e "NODE_ENV=production" \
    ghcr.io/openclaw/openclaw:latest
```

**部署后显示的信息：**
```
🌐 Web 访问:
   地址：http://localhost:<端口>
   控制面板：http://localhost:<端口>/control

📂 数据目录:
   路径：<数据目录>
   配置文件：<数据目录>/openclaw.json
   工作空间：<数据目录>/workspace

⚡ 快速命令:
   进入容器：docker exec -it <实例名称> bash
   查看日志：docker logs -f <实例名称>
   停止：docker stop <实例名称>
   启动：docker start <实例名称>
```

---

### 菜单 2️⃣：管理现有 OpenClaw 实例

查看并管理所有带 `openclaw=true` 标签的容器（包括已停止的）。

**步骤：**
```bash
bash src/openclaw-docker-setup.sh
# 选择 2
```

**实例列表示例：**
```
OpenClaw 实例列表:

1) openclaw-gateway - Up 2 hours
2) openclaw-test - Exited (0) 1 day ago
```

**选择实例后的操作：**

| 选项 | 操作 | 说明 |
|------|------|------|
| 1 | ✅ 启动 | `docker start <实例名称>` |
| 2 | ❌ 停止 | `docker stop <实例名称>` |
| 3 | 🔄 重启 | `docker restart <实例名称>` |
| 4 | 📊 查看状态 | 显示名称、状态、端口信息 |
| 5 | 📜 查看日志 | `docker logs -f <实例名称>` |
| 6 | 🗑️ 删除 | 先停止，再删除容器（数据目录保留） |
| 7 | ⬅️ 返回 | 返回主菜单 |

---

### 菜单 3️⃣：进入容器进行高级操作

对**运行中**的容器执行操作。

**步骤：**
```bash
bash src/openclaw-docker-setup.sh
# 选择 3
# 选择要操作的容器
```

**子操作：**

**1. 🚀 运行 OpenClaw onboard（推荐）**

在容器内执行：
```bash
npx openclaw@latest onboard --install-daemon
```

Onboard 会引导你完成所有配置：
- Gateway 配置（端口、认证等）
- 工作空间配置
- LLM 模型配置（OpenAI / Claude / Gemini 等）
- 通讯频道配置（WhatsApp / Telegram / Slack 等）
- 技能和插件配置

**2. 🔧 运行特定的 OpenClaw 命令**

输入自定义命令在容器内执行，例如：
```bash
openclaw doctor          # 诊断问题
openclaw gateway --port 18789  # 启动 Gateway
openclaw agent "Hello"   # 发送消息给 AI
```

**3. 💻 进入容器 Shell**

进入交互式 Bash Shell：
```bash
docker exec -it <实例名称> bash
```

输入 `exit` 退出 Shell。

**4. 📜 查看日志**

实时查看容器日志（按 `Ctrl+C` 退出）：
```bash
docker logs -f <实例名称>
```

**5. ⬅️ 返回**

返回主菜单。

---

### 菜单 4️⃣：故障诊断和修复

**步骤：**
```bash
bash src/openclaw-docker-setup.sh
# 选择 4
```

**子选项：**

**1. 🔍 系统诊断**

检查：
- Docker 是否已安装
- Docker daemon 是否运行
- Node.js 是否安装（宿主机）

**2. 🐳 Docker 诊断**

列出所有带 `openclaw=true` 标签的容器：
```bash
docker ps -a --filter "label=openclaw=true"
```

**3. 📊 查看所有容器**

显示所有 Docker 容器：
```bash
docker ps -a
```

**4. 🔧 自动修复**

进入自动修复子菜单：

| 选项 | 操作 |
|------|------|
| 1 | 重启所有 OpenClaw 容器 |
| 2 | 清理未使用的 Docker 资源（`docker system prune -f`） |
| 3 | 重新拉取最新镜像（`docker pull ghcr.io/openclaw/openclaw:latest`） |
| 4 | 返回 |

**5. ⬅️ 返回**

返回主菜单。

---

### 菜单 5️⃣：帮助和文档

显示快速开始步骤和常用命令参考。

**显示内容包括：**
- 官方文档链接（网站、文档、GitHub）
- 快速开始步骤（创建实例 → 运行 onboard → 访问 Web UI）
- Onboard 安装流程说明
- 多实例管理方法
- 常用命令列表
- 技术支持渠道（Discord、GitHub Issues）

---

### 菜单 6️⃣：退出

退出脚本。

---

## 常见任务

### 任务 1：创建并完整配置 OpenClaw

```bash
# 1. 运行脚本
bash src/openclaw-docker-setup.sh

# 2. 选择菜单 1，输入实例名称和端口
# 实例名称: openclaw-gateway
# 端口: 18789
# 等待容器启动...

# 3. 选择菜单 3 → 选择容器 → 选择 1（运行 onboard）
# 按照向导完成配置：
# - 配置 Gateway
# - 配置工作空间
# - 配置 LLM 模型（OpenAI/Claude/Gemini）
# - 连接通讯频道（WhatsApp/Telegram/Slack）
# - 启用技能和插件

# 4. 在浏览器中访问
# http://localhost:18789
```

### 任务 2：查看实时日志

```bash
docker logs -f openclaw-gateway
# 按 Ctrl+C 停止查看日志
```

或通过菜单 3 → 选择容器 → 选择 4（查看日志）。

### 任务 3：创建多个实例

```bash
# 生产实例
bash src/openclaw-docker-setup.sh
# 名称：openclaw-prod，端口：18789
# 数据目录：~/openclaw-deployment/openclaw-prod

# 测试实例
bash src/openclaw-docker-setup.sh
# 名称：openclaw-test，端口：18790
# 数据目录：~/openclaw-deployment/openclaw-test

# 开发实例
bash src/openclaw-docker-setup.sh
# 名称：openclaw-dev，端口：18791
# 数据目录：~/openclaw-deployment/openclaw-dev

# 查看所有实例
docker ps -a --filter "label=openclaw=true"
```

### 任务 4：启动已停止的容器

```bash
# 方法 1: 通过菜单
bash src/openclaw-docker-setup.sh
# 选择菜单 2 → 选择实例 → 选择 1（启动）

# 方法 2: 直接命令
docker start openclaw-gateway
```

### 任务 5：查看实例详细信息

```bash
# 查看端口映射
docker port openclaw-gateway

# 查看资源使用情况
docker stats openclaw-gateway

# 查看容器详细配置
docker inspect openclaw-gateway
```

### 任务 6：在容器内运行 OpenClaw 命令

```bash
# 启动 onboard 向导
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon

# 启动 Gateway
docker exec -it openclaw-gateway openclaw gateway --port 18789

# 诊断问题
docker exec -it openclaw-gateway openclaw doctor

# 发送消息给 AI
docker exec -it openclaw-gateway openclaw agent "Hello"

# 查看配置文件
docker exec -it openclaw-gateway cat /home/node/.openclaw/openclaw.json
```

### 任务 7：备份数据

数据存储在宿主机目录，直接备份即可：

```bash
# 打包备份
tar czf openclaw-gateway-backup-$(date +%Y%m%d).tar.gz \
    -C ~/openclaw-deployment openclaw-gateway

# 查看备份
ls -lh openclaw-gateway-backup-*.tar.gz
```

### 任务 8：恢复数据

```bash
# 解压到数据目录
tar xzf openclaw-gateway-backup-<日期>.tar.gz \
    -C ~/openclaw-deployment
```

---

## 高级用法

### 使用环境变量自定义数据路径

```bash
# 使用自定义基础目录
OPENCLAW_PATH=/data/openclaw bash src/openclaw-docker-setup.sh
```

创建实例时数据目录默认为 `$OPENCLAW_PATH/<实例名称>`。

### 使用 Docker Compose

创建文件 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  openclaw-prod:
    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw-prod
    restart: unless-stopped
    ports:
      - "18789:18789"
    volumes:
      - ~/openclaw-deployment/openclaw-prod:/home/node/.openclaw
      - ~/openclaw-deployment/openclaw-prod/workspace:/workspace
    labels:
      - "openclaw=true"
    environment:
      - NODE_ENV=production

  openclaw-test:
    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw-test
    restart: unless-stopped
    ports:
      - "18790:18789"
    volumes:
      - ~/openclaw-deployment/openclaw-test:/home/node/.openclaw
      - ~/openclaw-deployment/openclaw-test/workspace:/workspace
    labels:
      - "openclaw=true"
    environment:
      - NODE_ENV=test
```

启动所有服务：

```bash
docker-compose up -d
```

停止所有服务：

```bash
docker-compose down
```

---

## 故障排查

### 问题 1: 容器无法启动

**症状：** 创建容器后立即停止

**排查步骤：**
```bash
# 1. 查看容器日志
docker logs openclaw-gateway

# 2. 检查是否有错误信息
docker ps -a --filter "label=openclaw=true"

# 3. 通过菜单 4 → 系统诊断 确认 Docker 正常
bash src/openclaw-docker-setup.sh
# 选择菜单 4 → 选择 1
```

### 问题 2: 无法访问 Web 界面

**症状：** 浏览器显示连接拒绝

**排查步骤：**
```bash
# 1. 检查容器是否运行
docker ps --filter "label=openclaw=true"

# 2. 检查端口映射
docker port openclaw-gateway

# 3. 检查容器日志
docker logs openclaw-gateway
```

### 问题 3: 容器磁盘占用过多

**解决方案：**
```bash
# 通过菜单 4 → 自动修复 → 清理未使用的 Docker 资源

# 或手动清理
docker system prune -f
```

### 问题 4: OpenClaw 响应缓慢

**解决方案：**
```bash
# 1. 查看容器资源使用情况
docker stats openclaw-gateway

# 2. 在 Docker Desktop 中增加资源
# macOS/Windows: Docker Desktop → Preferences → Resources

# 3. 通过菜单 2 → 选择实例 → 选择 3（重启）重启容器
```

---

## 最佳实践

### ✅ 建议做法

1. **使用有意义的实例名称**
   ```
   # 好的
   openclaw-prod
   openclaw-test
   openclaw-dev

   # 不好的
   container1
   temp
   aaa
   ```

2. **定期备份数据**
   ```bash
   # 数据在宿主机目录，直接备份
   tar czf backup-$(date +%Y%m%d).tar.gz \
       -C ~/openclaw-deployment openclaw-gateway
   ```

3. **监控容器日志**
   ```bash
   # 在终端中持续查看日志
   docker logs -f openclaw-gateway
   ```

4. **为不同用途创建不同的实例**
   - 生产（稳定配置）
   - 测试（功能测试）
   - 开发（实验性）

### ❌ 避免做法

1. **不要手动删除容器内的配置目录**
   - 通过 onboard 重新配置会更安全

2. **不要忽略容器日志**
   - 日志能帮助快速定位问题

3. **不要在多个实例中使用同一个端口**
   - 每个实例需要独立的宿主机端口

---

## 🆘 获取帮助

### 查看帮助菜单
```bash
bash src/openclaw-docker-setup.sh
# 选择菜单 5
```

### 运行诊断
```bash
bash src/openclaw-docker-setup.sh
# 选择菜单 4 → 选择 1
```

### 查看官方文档
- [OpenClaw 官方网站](https://openclaw.ai)
- [OpenClaw 文档](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)

### 报告问题和技术支持
- 💬 Discord: [https://discord.gg/clawd](https://discord.gg/clawd)
- 📧 Issues: [GitHub Issues](https://github.com/kaisleung96/openclaw-docker-setup/issues)

---

**需要帮助？不要犹豫，提交问题或加入 Discord！** 🤝
