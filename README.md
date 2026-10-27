# ClaudeToggle

一个 macOS 顶栏小程序，一键开关 Claude Code 的 CLAUDE.md 和技能包。

![macOS 12+](https://img.shields.io/badge/macOS-12%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.7%2B-orange)

## 功能

- **顶栏常驻** — 原生 SF Symbols 盾牌图标，自动适配深色/浅色模式
- **三档开关** — CLAUDE.md 总开关 / 逆向工程技能包 / 渗透测试技能包
- **快捷预设** — 全部启用 / 仅逆向 / 仅渗透 / 仅基础 / 全部关闭
- **模板拼接** — CLAUDE.md 由模块化模板片段按需组装
- **专属图标** — Core Graphics 手绘 `.icns` 应用图标

### 顶栏图标状态

| 图标 | 状态 |
|------|------|
| `shield.fill` | 全部启用 |
| `shield.lefthalf.filled` | 启用一个技能包 |
| `shield` | 仅基础配置 |
| `shield.slash` | CLAUDE.md 已禁用 |

## 安装

### 方式一：直接下载（推荐）

前往 [Releases](https://github.com/xiaye907/claude-toggle/releases) 下载最新版 zip，解压后将 `ClaudeToggle.app` 放到你的 Claude Code 项目根目录。

首次打开：右键 → 打开（绕过 Gatekeeper）。

### 方式二：从源码编译

```bash
git clone https://github.com/xiaye907/claude-toggle.git
cd claude-toggle

# 编译（需要 Xcode Command Line Tools）
bash .claude-toggle/build.sh

# 启动
open ClaudeToggle.app
```

## 使用方法

1. 将 `ClaudeToggle.app` 放到 Claude Code 项目根目录（CLAUDE.md 所在位置）
2. 把你的 CLAUDE.md 拆分成模板片段，放到 `.claude-toggle/parts/` 下：
   - `base.md` — 基础配置（启用时始终包含）
   - `skill-row-*.md` — 技能包表格行
   - `reverse.md` — 逆向工程路由规则
   - `pentest.md` — 渗透测试路由规则
   - `priority.md` — 路由优先级（仅两个技能包同时启用时包含）
   - `footer.md` — 工具路径和服务配置
3. 双击 `ClaudeToggle.app` — 顶栏出现盾牌图标
4. 点击图标切换技能包开关
5. 开机自启：系统设置 → 通用 → 登录项 → 添加 `ClaudeToggle.app`

## 项目结构

```
.claude-toggle/
├── build.sh              # 构建脚本（编译 + 图标生成 + .app 打包）
├── config.json           # 开关状态（自动生成，git 忽略）
├── parts/                # CLAUDE.md 模板片段（git 忽略，用户自定义）
└── src/
    ├── ClaudeToggle.swift # 顶栏应用源码
    ├── GenerateIcon.swift # 应用图标生成器（Core Graphics）
    └── Info.plist         # 应用配置（LSUIElement 顶栏模式）
```

## 工作原理

`.claude-toggle/parts/` 中的模板是内容的唯一来源。切换开关时：

1. 更新 `config.json` 记录开关状态
2. 根据启用的模板片段重新拼接生成 `CLAUDE.md`
3. 关闭 CLAUDE.md 总开关会直接删除文件 — Claude Code 不加载任何项目指令

新的 Claude Code 会话会自动读取最新配置。

## 自定义

编辑 `.claude-toggle/parts/` 中的模板文件来修改 CLAUDE.md 的内容。应用会根据开关状态自动拼接。模板内容 git 忽略，仓库只包含应用源码。

## 系统要求

- macOS 12+
- 编译需要 Xcode Command Line Tools（`xcode-select --install`）
- 直接下载使用无需编译环境
