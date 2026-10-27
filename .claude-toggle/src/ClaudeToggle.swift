import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    struct Config: Codable {
        var claudeMdEnabled: Bool = true
        var reverseSkillEnabled: Bool = true
        var pentestSkillEnabled: Bool = true
    }

    var config = Config()

    var projectDir = ""
    var toggleDir = ""
    var partsDir = ""
    var configPath = ""
    var claudeMdPath = ""

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        let bundlePath = Bundle.main.bundlePath
        projectDir = (bundlePath as NSString).deletingLastPathComponent
        toggleDir = projectDir + "/.claude-toggle"
        partsDir = toggleDir + "/parts"
        configPath = toggleDir + "/config.json"
        claudeMdPath = projectDir + "/CLAUDE.md"

        guard FileManager.default.fileExists(atPath: partsDir + "/base.md") else {
            let a = NSAlert()
            a.messageText = "模板未找到"
            a.informativeText = "缺少 .claude-toggle/parts/ 模板文件\n请将 ClaudeToggle.app 放在项目根目录"
            a.runModal()
            NSApp.terminate(nil)
            return
        }

        loadConfig()
        setupStatusItem()
    }

    // MARK: - SF Symbols

    func sfIcon(_ name: String, size: CGFloat = 16, weight: NSFont.Weight = .medium) -> NSImage? {
        let cfg = NSImage.SymbolConfiguration(pointSize: size, weight: weight)
        guard let img = NSImage(systemSymbolName: name, accessibilityDescription: nil)?
            .withSymbolConfiguration(cfg) else { return nil }
        img.isTemplate = true
        return img
    }

    // MARK: - Status Item

    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateIcon()
        rebuildMenu()
    }

    func updateIcon() {
        guard let btn = statusItem?.button else { return }

        let name: String
        let fallback: String
        if !config.claudeMdEnabled {
            name = "shield.slash"; fallback = "⊘"
        } else if config.reverseSkillEnabled && config.pentestSkillEnabled {
            name = "shield.fill"; fallback = "●"
        } else if config.reverseSkillEnabled || config.pentestSkillEnabled {
            name = "shield.lefthalf.filled"; fallback = "◐"
        } else {
            name = "shield"; fallback = "○"
        }

        if let img = sfIcon(name, size: 16, weight: .semibold) {
            btn.image = img
            btn.title = ""
        } else {
            btn.image = nil
            btn.title = fallback
        }
    }

    // MARK: - Menu

    func rebuildMenu() {
        let menu = NSMenu()
        menu.autoenablesItems = false

        // Status header
        let summary = statusSummary()
        let header = NSMenuItem(title: summary, action: nil, keyEquivalent: "")
        header.isEnabled = false
        header.attributedTitle = NSAttributedString(
            string: summary,
            attributes: [
                .font: NSFont.monospacedSystemFont(ofSize: 11, weight: .medium),
                .foregroundColor: NSColor.secondaryLabelColor
            ]
        )
        menu.addItem(header)
        menu.addItem(.separator())

        // Main toggle
        menu.addItem(item("CLAUDE.md", #selector(toggleClaudeMd), "1",
                          state: config.claudeMdEnabled, icon: "doc.text.fill"))
        menu.addItem(.separator())

        // Skill packs
        menu.addItem(item("逆向工程  (21 模块 + 41 CTF)", #selector(toggleReverse), "2",
                          state: config.reverseSkillEnabled,
                          enabled: config.claudeMdEnabled, icon: "cpu"))
        menu.addItem(item("渗透测试  (68 技能)", #selector(togglePentest), "3",
                          state: config.pentestSkillEnabled,
                          enabled: config.claudeMdEnabled, icon: "network"))
        menu.addItem(.separator())

        // Presets submenu
        let sub = NSMenu()
        sub.addItem(preset("全部启用", #selector(presetFull), "shield.fill"))
        sub.addItem(preset("仅逆向", #selector(presetReverseOnly), "cpu"))
        sub.addItem(preset("仅渗透", #selector(presetPentestOnly), "network"))
        sub.addItem(preset("仅基础配置", #selector(presetBaseOnly), "shield"))
        sub.addItem(.separator())
        sub.addItem(preset("全部关闭", #selector(presetOff), "shield.slash"))

        let presetsItem = NSMenuItem(title: "快捷预设", action: nil, keyEquivalent: "")
        presetsItem.image = sfIcon("slider.horizontal.3", size: 13)
        presetsItem.submenu = sub
        menu.addItem(presetsItem)

        menu.addItem(.separator())
        menu.addItem(item("编辑模板…", #selector(openTemplates), "e",
                          icon: "folder.badge.gearshape"))
        menu.addItem(item("在 Finder 中显示", #selector(revealProject), "",
                          icon: "folder"))
        menu.addItem(.separator())
        menu.addItem(item("退出 ClaudeToggle", #selector(quitApp), "q"))

        statusItem.menu = menu
    }

    // MARK: - Menu Item Builders

    func item(_ title: String, _ action: Selector, _ key: String,
              state: Bool = false, enabled: Bool = true, icon: String? = nil) -> NSMenuItem {
        let mi = NSMenuItem(title: title, action: action, keyEquivalent: key)
        mi.target = self
        mi.state = state ? .on : .off
        mi.isEnabled = enabled
        if let n = icon { mi.image = sfIcon(n, size: 13) }
        return mi
    }

    func preset(_ title: String, _ action: Selector, _ icon: String) -> NSMenuItem {
        let mi = NSMenuItem(title: title, action: action, keyEquivalent: "")
        mi.target = self
        mi.image = sfIcon(icon, size: 13)
        return mi
    }

    func statusSummary() -> String {
        guard config.claudeMdEnabled else { return "CLAUDE.md 已禁用" }
        var p = [String]()
        if config.reverseSkillEnabled { p.append("逆向") }
        if config.pentestSkillEnabled { p.append("渗透") }
        return p.isEmpty ? "仅基础配置" : "已启用: " + p.joined(separator: " + ")
    }

    // MARK: - Toggle Actions

    @objc func toggleClaudeMd() { config.claudeMdEnabled.toggle(); apply() }
    @objc func toggleReverse()  { config.reverseSkillEnabled.toggle(); apply() }
    @objc func togglePentest()  { config.pentestSkillEnabled.toggle(); apply() }

    // MARK: - Presets

    @objc func presetFull() {
        config = Config(claudeMdEnabled: true, reverseSkillEnabled: true, pentestSkillEnabled: true); apply()
    }
    @objc func presetReverseOnly() {
        config = Config(claudeMdEnabled: true, reverseSkillEnabled: true, pentestSkillEnabled: false); apply()
    }
    @objc func presetPentestOnly() {
        config = Config(claudeMdEnabled: true, reverseSkillEnabled: false, pentestSkillEnabled: true); apply()
    }
    @objc func presetBaseOnly() {
        config = Config(claudeMdEnabled: true, reverseSkillEnabled: false, pentestSkillEnabled: false); apply()
    }
    @objc func presetOff() {
        config = Config(claudeMdEnabled: false, reverseSkillEnabled: false, pentestSkillEnabled: false); apply()
    }

    // MARK: - Utility

    @objc func openTemplates() { NSWorkspace.shared.open(URL(fileURLWithPath: partsDir)) }
    @objc func revealProject()  { NSWorkspace.shared.selectFile(claudeMdPath, inFileViewerRootedAtPath: projectDir) }
    @objc func quitApp()        { NSApp.terminate(nil) }

    // MARK: - Config & Apply

    func apply() {
        saveConfig()
        generateClaudeMd()
        updateIcon()
        rebuildMenu()
        flashStatus()
    }

    func loadConfig() {
        let url = URL(fileURLWithPath: configPath)
        guard let data = try? Data(contentsOf: url),
              let c = try? JSONDecoder().decode(Config.self, from: data) else { return }
        config = c
    }

    func saveConfig() {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? enc.encode(config) else { return }
        try? data.write(to: URL(fileURLWithPath: configPath))
    }

    func flashStatus() {
        guard let btn = statusItem?.button else { return }
        let saved = btn.image
        btn.image = nil
        btn.title = " " + statusSummary() + " "
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            btn.title = ""
            btn.image = saved
            self?.updateIcon()
        }
    }

    // MARK: - CLAUDE.md Generation

    func generateClaudeMd() {
        guard config.claudeMdEnabled else {
            try? FileManager.default.removeItem(atPath: claudeMdPath)
            return
        }

        var md = readPart("base.md")
        let rev = config.reverseSkillEnabled
        let pen = config.pentestSkillEnabled

        if rev || pen {
            md += "\n---\n\n## 技能包布局\n\n"
            if rev && pen { md += "两个技能仓库，分工明确：\n\n" }
            md += "| 技能包 | 路径 | 覆盖范围 | 规模 |\n"
            md += "|--------|------|----------|------|\n"
            if rev { md += readPart("skill-row-reverse.md") }
            if pen { md += readPart("skill-row-pentest.md") }
            md += "\n---\n\n## 路由规则\n\n任务进入时，按以下流程路由：\n\n"
            if rev { md += readPart("reverse.md") }
            if pen { md += readPart("pentest.md") }
            if rev && pen { md += readPart("priority.md") }
            md += readPart("footer.md")
        }

        try? md.write(toFile: claudeMdPath, atomically: true, encoding: .utf8)
    }

    func readPart(_ name: String) -> String {
        (try? String(contentsOfFile: partsDir + "/" + name, encoding: .utf8)) ?? ""
    }
}

// MARK: - Entry Point

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
