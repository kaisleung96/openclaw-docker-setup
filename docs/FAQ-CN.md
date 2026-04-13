# 常见问题解答（中文）

## 常见问题速查表

| 问题 | 快速答案 |
|------|--------|
| 如何创建实例？ | 运行脚本选菜单 1 |
| 默认实例名称是什么？ | `openclaw-gateway` |
| 默认端口是什么？ | `18789` |
| 如何运行 onboard？ | 菜单 3 → 选择容器 → 选择 1 |
| 如何进入容器 Shell？ | 菜单 3 → 选择容器 → 选择 3 |
| 如何查看日志？ | `docker logs -f <实例名称>` 或菜单 3 → 选择 4 |
| 如何停止实例？ | 菜单 2 → 选择实例 → 选择 2（停止） |
| 如何删除实例？ | 菜单 2 → 选择实例 → 选择 6（删除） |
| 数据存储在哪里？ | `~/openclaw-deployment/<实例名称>/` |
| 删除容器数据会丢吗？ | 不会，数据在宿主机目录中 |
| 如何自定义数据目录？ | 设置 `OPENCLAW_PATH` 环境变量 |

---

## 一般问题

### Q1: 这个项目是做什么的？

**A:** 这是一个交互式 CLI 工具，用于在 Docker 容器中快速部署和管理 OpenClaw。

**好处：**
- ✅ 隔离运行 - 不会影响你的主机系统
- ✅ 快速启动 - 交互式菜单，无需手动执行 Docker 命令
- ✅ 集成官方 onboard - 一键完成所有配置
- ✅ 数据安全 - 所有数据存储在宿主机目录（绑定挂载）
- ✅ 易于管理 - 支持多个独立实例

### Q2: 这和直接在主机上安装 OpenClaw 有什么区别？

**A:** 主要区别：

| 方面 | Docker 方案 | 直接安装 |
|------|----------|--------|
| 隔离性 | ⭐⭐⭐⭐⭐ 完全隔离 | ⭐ 无隔离 |
| 安全性 | ⭐⭐⭐⭐⭐ 很高 | ⭐⭐ 一般 |
| 易用性 | ⭐⭐⭐⭐⭐ 交互式菜单 | ⭐⭐⭐ 需要手动配置 |
| 管理性 | ⭐⭐⭐⭐⭐ 非常容易 | ⭐⭐ 困难 |
| 资源占用 | ⭐⭐⭐ 中等 | ⭐⭐⭐⭐ 较多 |

### Q3: 我需要学习 Docker 吗？

**A:** 不需要！

这个脚本提供了中文交互式菜单界面，你可以完全不懂 Docker：
- 选择菜单选项
- 输入实例名称和端口
- 脚本自动处理其他一切

**但了解一些基本命令会很有帮助：**
```bash
docker ps -a --filter "label=openclaw=true"  # 查看容器
docker logs -f <名称>                         # 查看日志
docker stop <名称>                            # 停止容器
```

### Q4: 系统要求是什么？

**A:** 最低要求：
- OS: macOS 10.15+、Linux、Windows 10+ (WSL2)
- 内存: 4GB（推荐 8GB）
- 磁盘: 10GB 空闲空间
- Docker: 最新版本

**不需要在宿主机安装 Node.js**，OpenClaw 运行在容器内。

### Q5: 这个项目是免费的吗？

**A:** 是的，完全免费！
- ✅ MIT 开源许可证
- ✅ 代码完全免费
- ✅ 可以商业使用
- ✅ 欢迎贡献

---

## 安装和设置

### Q6: 我应该先安装什么？

**A:** 按照以下顺序：

1. **Docker** - 核心依赖
   - [Docker Desktop for macOS/Windows](https://www.docker.com/products/docker-desktop)
   - [Docker for Linux](https://docs.docker.com/engine/install/)

2. **Git** - 用于克隆项目
   - [下载 Git](https://git-scm.com/downloads)

3. **本项目**
   ```bash
   git clone https://github.com/kaisleung96/openclaw-docker-setup.git
   ```

### Q7: macOS 和 Windows 有什么区别吗？

**A:** 对于这个脚本没有明显区别，但：
- **macOS**: 直接支持，只需下载 Docker Desktop
- **Windows**: 需要 WSL2，在安装 Docker Desktop 时会自动设置
- **Linux**: 需要手动安装 Docker

### Q8: WSL2 是什么？我需要它吗？

**A:** WSL2（Windows Subsystem for Linux 2）是在 Windows 上运行 Linux 的技术。
- Windows 10/11 用户**需要** WSL2 来运行 Docker
- Docker Desktop 可以自动安装 WSL2
- 安装完后你可以在 Windows Terminal 中使用 Linux 命令

---

## 使用问题

### Q9: 如何创建我的第一个实例？

**A:** 简单三步：

```bash
# 1. 运行脚本
bash src/openclaw-docker-setup.sh

# 2. 选择菜单 1（创建新的 OpenClaw）

# 3. 输入配置（直接按 Enter 使用默认值）
# 实例名称: openclaw-gateway（默认）
# 端口: 18789（默认）
# 数据目录: ~/openclaw-deployment/openclaw-gateway（默认）

# 完成！容器会自动启动
```

### Q10: 实例名称有什么限制吗？

**A:** Docker 容器名称需要：
- ✅ 只包含小写字母、数字、下划线和连字符
- ✅ 以字母或数字开头
- ✅ 最长 63 个字符

**好的名称：**
- openclaw-gateway（默认）
- openclaw-prod
- openclaw-test
- my-openclaw

**不好的名称：**
- OpenClaw（含大写）
- openclaw@prod（含特殊字符）
- 123openclaw（以数字开头）

### Q11: 我可以创建多个实例吗？

**A:** 完全可以！每个实例使用不同的名称和端口：

```bash
# 创建生产环境实例
bash src/openclaw-docker-setup.sh
# 输入：openclaw-prod，端口 18789

# 创建测试环境实例
bash src/openclaw-docker-setup.sh
# 输入：openclaw-test，端口 18790

# 创建开发环境实例
bash src/openclaw-docker-setup.sh
# 输入：openclaw-dev，端口 18791

# 查看所有实例
docker ps -a --filter "label=openclaw=true"
```

### Q12: 如何访问 OpenClaw Web 界面？

**A:**

1. 首先确保容器正在运行：
   ```bash
   docker ps --filter "label=openclaw=true"
   ```

2. 在浏览器中打开：
   ```
   http://localhost:18789
   ```
   （或你创建实例时指定的端口）

3. 控制面板：
   ```
   http://localhost:18789/control
   ```

### Q13: 如何运行 onboard 配置向导？

**A:**

**方法 1（推荐）：通过菜单**
```bash
bash src/openclaw-docker-setup.sh
# 选择菜单 3 → 选择容器 → 选择 1（运行 onboard）
```

**方法 2：直接命令**
```bash
docker exec -it openclaw-gateway npx openclaw@latest onboard --install-daemon
```

Onboard 会引导你完成：
- Gateway 配置（端口、认证等）
- 工作空间配置
- LLM 模型选择（OpenAI / Claude / Gemini 等）
- 通讯频道连接（WhatsApp / Telegram / Slack 等）
- 技能和插件启用

### Q14: onboard 运行后要做什么？

**A:**

Onboard 完成后：
1. 在浏览器打开 `http://localhost:18789`（或你的端口）
2. 进入 `http://localhost:18789/control` 查看控制面板
3. OpenClaw 即可正常使用

### Q15: 如何查看实例的实际端口？

**A:**

```bash
# 方法 1: 通过菜单 2 → 选择实例 → 选择 4（查看状态）
bash src/openclaw-docker-setup.sh

# 方法 2: 直接命令
docker port openclaw-gateway

# 方法 3: 查看所有实例及端口
docker ps -a --filter "label=openclaw=true" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

---

## 数据和备份

### Q16: 我的数据存储在哪里？

**A:** 数据通过绑定挂载存储在宿主机（不是 Docker Named Volume）：

```
~/openclaw-deployment/<实例名称>/
├── openclaw.json       # 配置文件
└── workspace/          # 工作空间目录
```

**查看数据目录：**
```bash
ls -la ~/openclaw-deployment/openclaw-gateway/
```

### Q17: 如何自定义数据存储位置？

**A:** 设置 `OPENCLAW_PATH` 环境变量：

```bash
OPENCLAW_PATH=/custom/path bash src/openclaw-docker-setup.sh
# 创建实例时数据目录默认为 /custom/path/<实例名称>
```

### Q18: 如何备份数据？

**A:** 数据在宿主机目录，直接打包即可：

```bash
# 备份单个实例
tar czf openclaw-gateway-backup-$(date +%Y%m%d).tar.gz \
    -C ~/openclaw-deployment openclaw-gateway

# 备份所有实例
tar czf openclaw-all-backup-$(date +%Y%m%d).tar.gz \
    ~/openclaw-deployment/

# 查看备份
ls -lh openclaw-*-backup-*.tar.gz
```

### Q19: 如何恢复备份？

**A:**

```bash
# 解压备份到数据目录
tar xzf openclaw-gateway-backup-<日期>.tar.gz \
    -C ~/openclaw-deployment

# 然后创建容器（使用原有数据目录路径）
bash src/openclaw-docker-setup.sh
# 菜单 1 → 实例名称: openclaw-gateway → 端口: 18789
# 数据目录: ~/openclaw-deployment/openclaw-gateway
```

### Q20: 删除容器会丢失数据吗？

**A:** **不会！**

数据存储在宿主机目录 `~/openclaw-deployment/<实例名称>/`，删除容器不影响数据。

```bash
# 删除容器
docker rm openclaw-gateway

# 数据仍然存在
ls ~/openclaw-deployment/openclaw-gateway/

# 可以重新创建容器并使用原有数据
bash src/openclaw-docker-setup.sh
```

---

## 故障排查

### Q21: 容器无法启动怎么办？

**A:** 按以下步骤排查：

```bash
# 1. 查看容器日志
docker logs openclaw-gateway

# 2. 尝试重启
docker restart openclaw-gateway

# 3. 通过菜单 4 → 系统诊断 确认环境
bash src/openclaw-docker-setup.sh
# 菜单 4 → 1

# 4. 如果仍不行，删除并重新创建
docker rm -f openclaw-gateway
bash src/openclaw-docker-setup.sh
```

### Q22: 无法访问 Web 界面怎么办？

**A:** 检查清单：

```bash
# 容器是否运行？
docker ps --filter "label=openclaw=true"

# 端口是否映射正确？
docker port openclaw-gateway
# 应该显示：18789/tcp -> 0.0.0.0:18789

# 容器日志是否有错误？
docker logs openclaw-gateway
```

### Q23: Docker 占用太多磁盘空间怎么办？

**A:**

```bash
# 通过菜单清理（推荐）
bash src/openclaw-docker-setup.sh
# 菜单 4 → 4 → 2（清理未使用的 Docker 资源）

# 或手动清理
docker system prune -f
docker image prune -a  # 清理所有未使用的镜像
```

---

## 高级问题

### Q24: 我可以修改脚本吗？

**A:** 完全可以！这是开源项目：

```bash
# 编辑脚本
vim src/openclaw-docker-setup.sh

# 修改默认值、添加功能等
# 保存并测试
bash src/openclaw-docker-setup.sh
```

### Q25: 我可以使用自己的 Docker 镜像吗？

**A:** 可以！编辑脚本中的镜像名称（约第 240 行）：

```bash
# 找到这一行
ghcr.io/openclaw/openclaw:latest

# 改为你的镜像
your-registry/your-image:tag
```

### Q26: 如何使用 Docker Compose？

**A:** 参考 [完整使用指南 - 高级用法](USAGE-CN.md#使用-docker-compose)

### Q27: 我可以为这个项目贡献代码吗？

**A:** 非常欢迎！

1. Fork 项目
2. 创建功能分支
3. 提交 Pull Request
4. 等待审核

详见 [CONTRIBUTING.md](../CONTRIBUTING.md)

---

## 获取更多帮助

**仍然有问题？**

1. 📖 查看完整文档
   - [安装指南](INSTALLATION-CN.md)
   - [使用指南](USAGE-CN.md)
   - [故障排查](TROUBLESHOOTING-CN.md)

2. 💬 加入 Discord
   - [https://discord.gg/clawd](https://discord.gg/clawd)

3. 🐛 提交 Issue
   - [GitHub Issues](https://github.com/kaisleung96/openclaw-docker-setup/issues)

4. 🌐 查看官方资源
   - [OpenClaw 网站](https://openclaw.ai)
   - [OpenClaw 文档](https://docs.openclaw.ai)

---

**记住：没有愚蠢的问题。欢迎提问！** 😊
