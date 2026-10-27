### 1. 逆向 / CTF / 红队任务

**入口**: `/Users/xia/Downloads/reverse-skill/skills/`

```
读 routing.md (或 routing_zh.md) → 三轴匹配(目标类型+意图+工具链) → 进入子模块 SKILL.md
```

**触发词**: APK, Android, IDA, r2, Frida, Hook, 二进制, 反编译, OLLVM, JS逆向, 抓包,
CTF, Pwn, ROP, exploit, 提权, 红队, 攻击链, HW, EDR绕过, 免杀, 固件, IoT,
内网渗透, 域渗透, 横向移动, 符号迁移, N-day, 补丁差分, 游戏逆向,
恶意软件, YARA, 供应链, LLM安全, 浏览器自动化, writeup,
Shodan, 网络空间测绘, 资产发现, 暴露面, favicon hash, JARM, 证书搜索, IoT搜索

**核心文件**:
- 总控: `skills/SKILL.md`
- 路由矩阵: `skills/routing.md` / `skills/routing_zh.md`
- 工具索引: `skills/tool-index.md`
- CTF 总控: `CTF-Sandbox-Orchestrator/ctf-sandbox-orchestrator/SKILL.md`

**模块清单**（21 个）:

| 模块 | 目录 | 场景 |
|------|------|------|
| 通用逆向 | `reverse-engineering/` | 全语言全平台、反分析对抗、OLLVM、CTF 模式库 |
| APK 逆向 | `apk-reverse/` | jadx 反编译、smali、Frida Hook、重打包 |
| IDA Pro | `ida-reverse/` | 72 工具 MCP、反编译、交叉引用、数据流 |
| radare2 | `radare2/` | CLI 侦察、反汇编、patch |
| JS 逆向 | `js-reverse/` | 签名定位、加密参数、运行时采样、Node 复现 |
| 渗透工具链 | `pentest-tools/` | Nmap/Nuclei/SQLMap/FFUF/Hashcat/MSF 等 20+ |
| 攻击链编排 | `attack-chain/` | 多阶段攻击路径、HW 演练、全流程渗透 |
| EDR 绕过 | `edr-bypass-re/` | hook 表逆向、ETW/AMSI、直接 syscall |
| 固件渗透 | `firmware-pentest/` | OWASP FSTM、binwalk、EMBA、QEMU 仿真 |
| Pwn 链 | `pwn-chain/` | 栈/堆/内核 pwn、pwntools、libc-database |
| N-day 差分 | `patch-diff-exploit/` | 补丁差分、CVE PoC、N-day 武器化 |
| 符号迁移 | `binary-diff/` | 跨版本符号迁移、LLM 批量迁移 |
| 移动逆向 | `mobile-reverse/` | Android + iOS、Frida/Objection |
| 恶意软件分析 | `malware-analysis/` | YARA/Sigma/沙箱/IOC |
| LLM 安全 | `llm-security/` | OWASP LLM + ASI Top 10 |
| API 安全 | `api-security/` | REST/GraphQL/JWT/OAuth |
| 供应链安全 | `supply-chain-security/` | SBOM/SCA/CI-CD |
| 浏览器自动化 | `browser-automation/` | Playwright + OpenReverse |
| 图表生成 | `diagram-generator/` | Mermaid/Graphviz/PlantUML |
| 文档生成 | `docs-generator/` | 逆向报告/渗透报告/CTF writeup |
| CTF 全栈 | `CTF-Sandbox-Orchestrator/` | 41 个子技能，总控编排 |
| Shodan 侦察 | `shodan-recon/` | 网络空间搜索、语法速查、API 自动化、资产测绘 |

