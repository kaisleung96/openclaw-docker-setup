# 故障排查指南（中文）

## 快速索引

- [Docker 相关问题](#docker-相关问题)
- [容器创建和运行问题](#容器创建和运行问题)
- [网络访问问题](#网络访问问题)
- [Onboard 安装问题](#onboard-安装问题)
- [性能问题](#性能问题)
- [数据和配置问题](#数据和配置问题)
- [常见错误信息](#常见错误信息)

---

## Docker 相关问题

### ❌ Docker 未安装

**症状：**
```
[✗] Docker 未安装
command not found: docker
```

**解决方案：**

```bash
# 1. 检查 Docker 是否安装
docker --version

# 2. 如果未安装，按照系统安装 Docker
# macOS (Homebrew)
brew install --cask docker

# Ubuntu/Debian
sudo apt-get install -y docker.io

# 3. 重启终端
exec bash

# 4. 再次验证
docker --version
```

### ❌ Docker daemon 未运行

**症状：**
```
[✗] Docker daemon 未运行
Cannot connect to Docker daemon
```

**解决方案：**

```bash
# macOS/Windows
# 打开 Applications 中的 Docker Desktop 应用

# Linux
sudo systemctl start docker

# 验证 Docker 运行中
docker ps

# 查看 Docker 状态
sudo systemctl status docker
```

### ❌ permission denied while trying to connect to Docker daemon

**症状：**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**解决方案：**

```bash
# 方法 1: 使用 sudo（不推荐长期使用）
sudo bash src/openclaw-docker-setup.sh

# 方法 2: 添加用户到 docker 组（推荐）
sudo usermod -aG docker $USER

# 需要注销并重新登录以应用权限
# 验证
groups $USER  # 应该看到 docker 组
docker ps     # 应该正常工作
```

---

## 容器创建和运行问题

### ❌ 容器创建失败 - 无法拉取镜像

**症状：**
```
Error response from daemon: Error pulling image
```

**解决方案：**

```bash
# 1. 检查网络连接
ping github.com

# 2. 手动拉取镜像
docker pull ghcr.io/openclaw/openclaw:latest

# 3. 通过菜单 4 → 自动修复 → 选择 3（重新拉取最新镜像）
bash src/openclaw-docker-setup.sh
# 菜单 4 → 4 → 3
```

### ❌ 容器立即退出

**症状：**
```
docker ps 看不到容器，但 docker ps -a 能看到
STATUS 显示 "Exited (1)"
```

**排查步骤：**

```bash
# 1. 查看详细日志
docker logs openclaw-gateway

# 2. 查看退出代码
docker ps -a --filter "label=openclaw=true"

# 常见退出代码：
# 0   - 正常退出
# 1   - 通用错误
# 127 - 命令不存在
# 137 - 容器被强制杀死（通常是内存不足）

# 3. 通过菜单 4 → 自动修复 → 重启容器
bash src/openclaw-docker-setup.sh
# 菜单 4 → 4 → 1
```

### ❌ 容器内存不足

**症状：**
```
JavaScript heap out of memory
Cannot allocate memory
```

**解决方案：**

```bash
# 1. 查看容器资源使用情况
docker stats openclaw-gateway

# 2. 增加 Docker 分配的内存
# macOS/Windows: Docker Desktop → Settings → Resources → Memory

# 3. 通过菜单 2 → 选择实例 → 选择 3（重启）
bash src/openclaw-docker-setup.sh
```

---

## 网络访问问题

### ❌ 无法访问 http://localhost:18789

**症状：**
```
ERR_CONNECTION_REFUSED
localhost 拒绝了连接
```

**排查步骤：**

```bash
# 1. 检查容器是否运行
docker ps --filter "label=openclaw=true"

# 2. 检查端口映射（应显示 18789/tcp -> 0.0.0.0:18789）
docker port openclaw-gateway

# 3. 容器内部网络测试
docker exec -it openclaw-gateway curl http://localhost:18789

# 4. 确认使用的是创建时指定的端口
# 通过菜单 2 查看实例的实际端口
bash src/openclaw-docker-setup.sh
# 菜单 2 → 选择实例 → 选择 4（查看状态）
```

### ❌ 端口已被占用

**症状：**
```
port is already allocated
Address already in use
```

**解决方案：**

```bash
# 1. 检查哪个进程占用了端口（Linux/macOS）
lsof -i :18789

# 2. 查看该端口是否被其他 Docker 容器占用
docker ps | grep 18789

# 3. 停止占用端口的容器
docker stop <容器名称>

# 4. 或创建新实例时使用不同的端口
bash src/openclaw-docker-setup.sh
# 菜单 1 → 输入新的端口号（如 18790）

# 5. Windows 上查找占用端口
netstat -ano | findstr :18789
taskkill /PID <PID> /F
```

### ❌ 防火墙阻止访问

**症状：**
```
连接超时
网络不可达
```

**解决方案：**

```bash
# macOS
# System Preferences → Security & Privacy → Firewall
# 确保 Docker 被允许

# Windows
# Windows Defender Firewall → Allow an app through firewall
# 确保 Docker Desktop 被允许

# Linux
sudo ufw allow 18789/tcp
# 或
sudo firewall-cmd --add-port=18789/tcp --permanent
```

---

## Onboard 安装问题

### ❌ onboard 命令失败

**症状：**
```
Error: Cannot find package 'openclaw'
npx: not found
```

**解决方案：**

```bash
# 1. 确认容器正在运行
docker ps --filter "label=openclaw=true"

# 2. 进入容器检查 Node.js 环境
docker exec -it openclaw-gateway bash
node --version
npm --version

# 3. 重新运行 onboard（通过菜单）
bash src/openclaw-docker-setup.sh
# 菜单 3 → 选择容器 → 选择 1（运行 onboard）
```

### ❌ onboard 卡住或无响应

**症状：**
```
onboard 程序启动后无任何输出
```

**解决方案：**

```bash
# 1. 按 Ctrl+C 停止当前 onboard
# 2. 重启容器
docker restart openclaw-gateway

# 3. 重新运行 onboard
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

### ❌ 配置保存失败

**症状：**
```
Error writing config file
Permission denied
```

**解决方案：**

```bash
# 1. 检查数据目录权限（宿主机）
ls -la ~/openclaw-deployment/openclaw-gateway/

# 2. 修复权限
chmod -R 755 ~/openclaw-deployment/openclaw-gateway/

# 3. 重启容器后重新运行 onboard
docker restart openclaw-gateway
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

---

## 性能问题

### ❌ 容器响应缓慢

**症状：**
```
Web 界面加载慢
命令执行时间长
```

**排查步骤：**

```bash
# 1. 检查资源使用情况
docker stats openclaw-gateway

# 2. 检查磁盘空间
docker system df
df -h ~/openclaw-deployment/

# 3. 查看容器日志找出瓶颈
docker logs -f openclaw-gateway

# 4. 如果 CPU/内存高
# 增加 Docker Desktop 分配的资源

# 5. 通过菜单 2 → 选择 3（重启）重启容器
```

### ❌ Docker 占用过多磁盘空间

**症状：**
```
磁盘空间迅速减少
```

**解决方案：**

```bash
# 1. 查看占用空间
docker system df

# 2. 通过菜单自动清理
bash src/openclaw-docker-setup.sh
# 菜单 4 → 4 → 2（清理未使用的 Docker 资源）

# 3. 或手动清理
docker container prune      # 清理停止的容器
docker image prune          # 清理未使用的镜像
docker system prune -f      # 一次性清理所有未使用的资源
docker builder prune        # 清理构建缓存
```

---

## 数据和配置问题

### ❌ 配置文件丢失或损坏

**症状：**
```
onboard 配置丢失
openclaw.json 损坏
```

**解决方案：**

```bash
# 1. 查看宿主机数据目录
ls -la ~/openclaw-deployment/openclaw-gateway/

# 2. 查看配置内容
cat ~/openclaw-deployment/openclaw-gateway/openclaw.json

# 3. 进入容器查看
docker exec -it openclaw-gateway cat /home/node/.openclaw/openclaw.json

# 4. 如果配置损坏，删除后重新运行 onboard
rm ~/openclaw-deployment/openclaw-gateway/openclaw.json
docker restart openclaw-gateway
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

### ❌ 删除容器后数据恢复

由于数据存储在宿主机目录（`~/openclaw-deployment/<实例名称>/`），删除容器**不会丢失数据**。

恢复方法（创建新容器并使用原有数据目录）：

```bash
# 使用脚本创建新容器，并指定原有数据目录
bash src/openclaw-docker-setup.sh
# 菜单 1 → 实例名称: openclaw-gateway → 端口: 18789
# 数据目录: ~/openclaw-deployment/openclaw-gateway（保持原路径）
```

---

## 常见错误信息

### "No space left on device"

```
Docker: Error response from daemon: mkdir ...: no space left on device
```

**解决方案：**
```bash
# 清理磁盘空间
docker system prune -f

# 或删除不需要的镜像
docker image prune -a
```

### "OCI runtime error"

```
docker: Error response from daemon: error creating container runtime
```

**解决方案：**
```bash
# macOS/Windows: 重新打开 Docker Desktop

# Linux
sudo systemctl restart docker
```

### "Cannot find image"

```
docker: Error response from daemon: No such image: ...
```

**解决方案：**
```bash
# 拉取镜像（或通过菜单 4 → 自动修复 → 3）
docker pull ghcr.io/openclaw/openclaw:latest
```

### "Error: Protocol error"

```
Error: Protocol error, stream error
```

**解决方案：**
```bash
# 检查网络连接
ping github.com

# 重试拉取镜像
docker pull ghcr.io/openclaw/openclaw:latest

# 如果仍然失败，尝试更换 DNS
# macOS: System Preferences → Network → DNS
```

---

## 内置诊断工具

通过脚本菜单运行内置诊断：

```bash
bash src/openclaw-docker-setup.sh
# 选择菜单 4 → 选择 1（系统诊断）
```

系统诊断会检查：
- Docker 安装状态
- Docker daemon 运行状态
- Node.js 安装状态

或手动运行诊断脚本：

```bash
#!/bin/bash
echo "=== OpenClaw Docker Setup - 诊断 ==="

echo "1. Docker 版本"
docker --version

echo ""
echo "2. Docker 状态"
docker ps > /dev/null 2>&1 && echo "运行中" || echo "未运行"

echo ""
echo "3. 磁盘空间"
docker system df

echo ""
echo "4. OpenClaw 容器列表"
docker ps -a --filter "label=openclaw=true"

echo ""
echo "5. 数据目录"
ls -la ~/openclaw-deployment/ 2>/dev/null || echo "数据目录不存在"

echo ""
echo "诊断完成。将上面的信息提供给技术支持人员。"
```

保存为 `diagnose.sh` 并运行：

```bash
chmod +x diagnose.sh
bash diagnose.sh > diagnostics.txt
```

---

## 获取帮助

如果以上方法都不能解决问题：

1. **收集诊断信息**
   ```bash
   bash diagnose.sh > diagnostics.txt
   ```

2. **加入 Discord 寻求帮助**
   - [https://discord.gg/clawd](https://discord.gg/clawd)

3. **提交 Issue**
   - [GitHub Issues](https://github.com/kaisleung96/openclaw-docker-setup/issues)
   - 包含诊断信息和错误截图

4. **查看官方文档**
   - [OpenClaw 文档](https://docs.openclaw.ai)

---

**记住：大多数问题都可以通过查看日志和使用菜单 4 的诊断工具来解决！** 🔍
