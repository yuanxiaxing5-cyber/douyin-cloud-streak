# Douyin Cloud Streak · 抖音云端自动续火花

> 每天定时自动给抖音好友发消息，维持「火花 / 连续聊天天数」。Docker 一键部署，网页端管理，无需手动安装任何依赖。

## ⚠️ 部署方式说明（重要）

**本项目唯一推荐部署方式：Docker 容器化部署。**

Docker 镜像已内置全部运行环境（Python、Playwright、Chromium 浏览器、所有依赖库），**用户不需要在本地手动安装 Python、Playwright、浏览器或任何依赖**。只需安装 Docker Desktop，执行两条命令即可运行。

> ❌ **不要在本地手动执行 `pip install`、`playwright install`、`python app.py` 等命令**，这些是开发调试用的，普通用户直接用 Docker 部署即可。

## 项目简介

本项目通过 Playwright 模拟浏览器操作抖音网页版，实现：
- 每日定时自动给勾选的好友发送自定义消息
- 网页端图形化管理（好友勾选、发送时间/内容设置、日志查看）
- 手机扫码登录，无需手动提取 Cookie
- 多账号隔离管理

## 技术栈（全部封装在 Docker 镜像内，无需本地安装）

| 层级 | 技术 |
|------|------|
| 后端 | Python 3.11 + FastAPI + Uvicorn |
| 浏览器自动化 | Playwright (Chromium) + playwright-stealth |
| 定时调度 | APScheduler |
| 前端 | Vue 3 + Element Plus（静态文件，无需构建） |
| 部署 | Docker + docker-compose |
| 数据存储 | 本地 JSON 文件（无数据库依赖） |

## 功能特性

- ✅ **定时自动发送**：可设置每日发送时间和随机浮动窗口（模拟真人行为）
- ✅ **好友台账管理**：自动同步抖音私信会话列表，显示昵称、头像、火花天数
- ✅ **网页端管理**：好友勾选、专属文案、发送时间、日志查看，全部网页操作
- ✅ **手机扫码登录**：网页端直接生成二维码，手机抖音扫码即可登录
- ✅ **多账号支持**：一个服务管理多个抖音账号，数据完全隔离
- ✅ **头像本地缓存**：自动下载好友头像到本地，避免抖音 CDN URL 过期失效
- ✅ **反风控设计**：单工作线程串行执行、全局浏览器并发上限、随机浮动时间、限流关键词检测
- ✅ **失败自动补发**：发送失败的好友 45 分钟后自动补发一次

## 快速开始（Docker 部署，唯一推荐方式）

> ✅ **此方式无需手动安装 Python、Playwright、浏览器或任何依赖库**，全部已封装在 Docker 镜像中。只需安装 Docker Desktop，执行两条命令即可运行。

### 前置要求（只需装一个 Docker Desktop）

- **Windows / macOS**：安装 [Docker Desktop](https://www.docker.com/products/docker-desktop/)（自带 Docker Engine 和 Docker Compose v2，安装后启动即可）
- **Linux**：安装 Docker Engine 20.10+ 和 Docker Compose v2 插件
- 国内网络环境建议配置 Docker 镜像加速器（见下方说明）

> 💡 **Windows 用户提示**：安装 Docker Desktop 后，在开始菜单启动它，等待左下角显示 "Engine running" 后，在项目目录打开 PowerShell 执行下方命令即可。
>
> ❌ **不需要**：安装 Python、安装 Playwright、下载浏览器、配置任何环境变量。

### 部署步骤

1. **克隆项目**

```bash
git clone https://github.com/Yuriz132/douyin-cloud-streak.git
cd douyin-cloud-streak
```

2. **修改访问口令（重要）**

编辑 `docker-compose.yml`，将 `AUTH_TOKEN` 的值改为你自己的安全口令：

```yaml
environment:
  - AUTH_TOKEN=your_secure_token_here  # 改成你自己的
```

3. **构建并启动**

在项目目录打开终端（Windows 用 PowerShell，Mac/Linux 用 Terminal），执行：

```bash
# 国内网络加加速参数构建（首次约 3-8 分钟，需下载 Playwright 浏览器）
docker compose build --build-arg USE_CN_MIRROR=1

# 后台启动容器
docker compose up -d
```

> 💡 **Docker Desktop 用户**：构建和启动过程可以在 Docker Desktop 界面看到容器状态和日志，启动成功后容器状态为 "Running"。

### 国内 Docker 镜像加速（可选但推荐）

如果构建时拉取基础镜像慢或超时，配置 Docker 镜像加速器：

**Docker Desktop（Windows/Mac）：**
1. 打开 Docker Desktop → 右上角设置（齿轮图标）→ Docker Engine
2. 在 JSON 配置中添加 `registry-mirrors`：

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://mirror.baidubce.com"
  ]
}
```

3. 点击 "Apply & restart" 重启 Docker Desktop

**Linux：**
编辑 `/etc/docker/daemon.json`（没有就新建），写入上面的配置后执行 `systemctl restart docker`。

4. **访问网页端**

浏览器打开 `http://localhost:8000`（或服务器 IP:8000），输入刚才设置的口令。

5. **扫码登录**

进入「凭证」页面 → 点击「手机扫码登录」→ 用抖音 App 扫码。

6. **同步并勾选好友**

进入「好友」页面 → 点击「同步联系人」→ 勾选要续火花的好友 → 「保存勾选配置」。

7. **设置发送时间和内容**

进入「定时」页面 → 设置每日发送时间、随机浮动分钟、发送内容 → 保存。

## 进阶：本地直接运行（不推荐，仅用于开发调试）

> ⚠️ **警告：此方式仅用于开发者本地调试，普通用户请使用上方 Docker 部署方式。**
> 
> 此方式需要手动安装 Python、依赖库、Playwright 浏览器，环境配置复杂，容易出错。普通用户直接用 Docker 即可，无需安装任何东西。

### 前置要求（开发者）

- Python 3.11+
- Windows / Linux / macOS
- 熟悉 Python 环境配置

### 运行步骤（开发者调试用）

```bash
# 1. 克隆项目
git clone https://github.com/Yuriz132/douyin-cloud-streak.git
cd douyin-cloud-streak

# 2. 安装依赖（国内建议用清华源）
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 3. 安装 Playwright 浏览器（必须，否则无法运行）
playwright install chromium

# 4. 设置访问口令（可选，默认无口令）
# Windows:
set AUTH_TOKEN=your_token
# Linux/macOS:
export AUTH_TOKEN=your_token

# 5. 启动服务
python app.py
```

访问 `http://localhost:8000`。

## Windows 本地静默运行（低内存推荐）

> 💡 **适用场景**：Windows 用户，内存紧张（如 8GB 以下），不想用 Docker（WSL2 约占 2GB 内存）。
>
> 此方式内存占用仅约 **80MB**，完全静默运行，无控制台窗口，支持开机自启动。

### 1. 安装 Python

下载安装 [Python 3.12](https://www.python.org/downloads/)，安装时勾选 **"Add Python to PATH"**。

验证安装：
```powershell
python --version
```

### 2. 创建虚拟环境并安装依赖

在项目目录打开 PowerShell：

```powershell
cd douyin-cloud-streak
python -m venv venv
.\venv\Scripts\pip install -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/
```

### 3. 安装 Playwright 浏览器

```powershell
$env:PLAYWRIGHT_DOWNLOAD_HOST="https://npmmirror.com/mirrors/playwright"
.\venv\Scripts\playwright install chromium
```

### 4. 配置访问口令

编辑 `start_silent.vbs`，修改口令：
```vbscript
WshShell.Environment("Process")("AUTH_TOKEN") = "你的口令"
```

### 5. 静默启动

双击 `start_silent.vbs`，完全无窗口闪现。

验证：浏览器打开 `http://localhost:8000`，能访问即成功。

### 6. 配置开机自启动（可选）

用 Windows 任务计划程序实现登录后自动静默启动：

```powershell
schtasks /create /tn "DouyinCloudStreak" /tr "wscript.exe \"项目完整路径\start_silent.vbs\"" /sc onlogon /rl highest /f
```

或手动操作：任务计划程序 → 创建基本任务 → 触发器"登录时" → 操作"启动程序" → 选择 `start_silent.vbs`。

### 内存对比

| 运行方式 | 内存占用 |
|----------|----------|
| Docker Desktop + WSL2 | ~1,900 MB |
| **本地静默运行** | **~80 MB** |

### 停止服务

任务管理器 → 详细信息 → 结束 `python.exe` 进程。

## 配置说明

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `AUTH_TOKEN` | 空 | 网页端访问口令，为空则不校验 |
| `PORT` | `8000` | 服务监听端口 |

### 网页端可配置项

| 配置 | 默认值 | 说明 |
|------|--------|------|
| 每日发送时间 | `21:00` | 定时发送的基准时间 |
| 随机浮动时间 | `30` 分钟 | 在基准时间前后随机浮动，模拟真人 |
| 发送内容 | `🔥` | 每行一条，随机选取发送 |
| 自动运行开关 | 开启 | 关闭后定时任务不触发 |
| 周级采集日 | `off` | 每周自动采集创作者平台好友映射的时间 |

## 目录结构

```
douyin-cloud-streak/
├── app.py                    # FastAPI 后端入口
├── core/
│   ├── automation.py         # 核心自动化：同步联系人、发送消息
│   ├── browser.py            # Playwright 浏览器实例池与管理
│   ├── ledger.py             # 好友台账管理（增删改查、头像下载）
│   ├── avatar.py             # 头像本地缓存
│   ├── accounts.py           # 多账号管理与全局并发控制
│   ├── config.py             # 配置与路径管理
│   ├── scheduler.py          # APScheduler 定时任务调度
│   ├── executor.py           # 单工作线程任务执行器
│   ├── guard.py              # 限流/验证码关键词检测
│   ├── login_session.py      # 扫码登录会话管理
│   ├── runtime.py            # 运行时状态与日志
│   ├── msg_builder.py        # 消息内容构建
│   ├── harvester/            # 创作者平台好友映射采集
│   └── sender/               # 消息发送通道（私信页/创作者页）
├── static/
│   ├── index.html            # 前端单页应用（Vue 3 + Element Plus）
│   └── vendor/               # 前端依赖库
├── tests/                    # 单元测试
├── data/                     # 运行数据（git 已忽略）
│   ├── state.json            # 登录凭证（默认账号）
│   ├── config.json           # 配置（默认账号）
│   ├── ledger.json           # 好友台账（默认账号）
│   ├── runtime.json          # 运行时状态
│   ├── avatars/              # 头像缓存
│   ├── logs/                 # 日志文件
│   └── accounts/             # 多账号数据目录
├── Dockerfile                # Docker 镜像构建文件
├── docker-compose.yml        # Docker Compose 配置
├── requirements.txt          # Python 依赖
├── 1.本地运行.bat             # Windows 本地运行脚本
└── 2.上传本地文件加服务器部署.bat  # Windows 服务器部署脚本
```

## 数据存储说明

本项目不使用数据库，所有数据以 JSON 文件存储在 `data/` 目录：

- **登录凭证**：`data/state.json`（抖音网页版 Cookie）
- **好友台账**：`data/ledger.json`（好友列表、勾选状态、火花天数、头像）
- **配置**：`data/config.json`（发送时间、内容等）
- **运行时状态**：`data/runtime.json`（最近运行记录、重试状态）
- **头像缓存**：`data/avatars/`（下载到本地的好友头像）

多账号模式下，各账号数据独立存储在 `data/accounts/{account_id}/`。

## API 接口

所有接口需在请求头携带 `X-Auth-Token`（如果设置了 `AUTH_TOKEN`）。

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/ledger` | 获取好友台账 |
| POST | `/api/sync` | 后台同步联系人 |
| POST | `/api/ledger/selection` | 保存勾选的好友 |
| GET | `/api/config` | 获取配置 |
| POST | `/api/config` | 保存配置 |
| POST | `/api/run` | 立即执行发送（支持 dry-run） |
| GET | `/api/logs` | 获取运行日志 |
| GET | `/api/accounts` | 获取账号列表 |
| POST | `/api/accounts` | 新建账号 |
| POST | `/api/login/qrcode` | 生成扫码登录二维码 |
| GET | `/api/login/status` | 查询登录状态 |

## 常见问题

### Q: 部署后完整的使用流程是什么？

A: 按以下顺序操作：
1. `docker compose build && docker compose up -d` 启动服务
2. 浏览器打开 `http://localhost:8000`，输入口令登录
3. 「凭证」页 → 「手机扫码登录」→ 用抖音 App 扫码
4. 「好友」页 → 点击「同步联系人」（**首次建议同步 2-3 次**，让系统收集完整的昵称和头像映射）
5. 勾选要续火花的好友 → 「保存勾选配置」
6. 「定时」页 → 设置发送时间、浮动分钟、发送内容 → 保存
7. 可以点击「立即发送」测试一次（建议先用 dry-run 模式）

### Q: 同步联系人后显示数字 ID 而不是昵称？

A: 抖音私信页对陌生人临时会话 initially 只显示 uid，系统会自动通过接口收集 uid→昵称映射并替换。**首次同步建议连续点击 2-3 次「同步联系人」**，让系统滚动整个会话列表收集完整映射。若个别好友接口始终未返回信息，可在网页端手动编辑昵称。

### Q: 头像不显示或显示灰色默认图？

A: 系统会自动下载所有好友头像到本地缓存（避免抖音 CDN URL 过期）。若仍有默认图，**重新点击 1-2 次「同步联系人」**即可，系统会补全缺失的头像。

### Q: 同步联系人后出现了很多我关注的人？

A: 已修复。系统现在只同步抖音私信会话列表里的好友，不会把关注的人加进来。前端默认只显示有私信会话的好友，如果想看全部，可以在好友列表顶部切换显示模式。

### Q: 构建镜像时拉取基础镜像很慢或失败？

A: 国内网络必须配置 Docker 镜像加速器，见上方「国内 Docker 镜像加速」章节。配置后重启 Docker Desktop 再重新构建。

### Q: 登录态多久过期？

A: 抖音网页版登录态一般维持几天到几周，过期后在「凭证」页重新扫码即可。

### Q: 如何更新版本？

```bash
git pull
docker compose up -d --build
```

数据在 `data/` 目录，更新不会丢失。

### Q: 如何备份数据？

直接打包 `data/` 目录即可：

```bash
tar czf streak-backup.tar.gz data/
```

## 注意事项

1. 建议使用国内服务器或本地家庭网络运行，境外 IP 容易触发抖音风控
2. 建议单账号每日发送不超过 20 人，避免触发限流
3. 首次使用建议先用小号试跑确认稳定
4. 本项目仅供个人学习和亲友间互动使用，请勿用于商业营销或批量骚扰

## 免责声明

使用本项目所产生的一切账号与法律后果均由使用者自行承担。请严格遵守抖音《用户服务协议》与社区公约。

---

**祝你的火花一直亮着！🔥**
