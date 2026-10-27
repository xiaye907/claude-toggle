### 3. 路由优先级

当任务同时匹配两个技能包时：
- **工具链驱动的任务**（Nmap 扫描、Frida Hook、IDA 分析）→ 走 reverse-skill
- **漏洞类型驱动的任务**（SQL 注入手法、XSS payload、SSRF 利用链）→ 走 pentest skills
- **混合场景**（渗透中发现需要逆向）→ 先用 reverse-skill 路由，按需加载 pentest skill

