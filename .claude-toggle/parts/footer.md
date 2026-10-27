---

## 工具路径约定

- 逆向工具路径从 `reverse-skill/skills/tool-index.md` 读取，**禁止猜测路径**
- 缺少工具时调用 bootstrap 脚本自动安装（macOS）:
  ```
  bash /Users/xia/Downloads/reverse-skill/skills/scripts/bootstrap-reverse.sh <工具名> --start-services
  ```
- 安装失败 2 次后给出手动安装步骤

## MCP 服务

| 服务 | 端口/方式 | 用途 |
|------|-----------|------|
| jshookmcp | npx @jshookmcp/jshook | JS Hook / CDP / SourceMap |
| anything-analyzer | localhost:23816 | 浏览器自动化 + HTTP 捕获 |
| idapro | 127.0.0.1:13337 | IDA Pro 72 工具 |
| ghidra | localhost:8765 | Ghidra 无头分析 |
| burpsuite | localhost:9876 | BurpSuite MCP |
