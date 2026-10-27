import Cocoa

let iconSize: CGFloat = 1024

func shieldPath(in rect: NSRect) -> NSBezierPath {
    let path = NSBezierPath()
    let w = rect.width
    let h = rect.height
    let cx = rect.midX
    let cy = rect.midY

    let topY = rect.maxY
    let botY = rect.minY
    let leftX = rect.minX
    let rightX = rect.maxX

    path.move(to: NSPoint(x: cx, y: topY))

    path.curve(to: NSPoint(x: rightX, y: topY - h * 0.13),
               controlPoint1: NSPoint(x: cx + w * 0.38, y: topY),
               controlPoint2: NSPoint(x: rightX, y: topY))

    path.curve(to: NSPoint(x: cx, y: botY),
               controlPoint1: NSPoint(x: rightX, y: cy + h * 0.03),
               controlPoint2: NSPoint(x: cx + w * 0.13, y: botY + h * 0.15))

    path.curve(to: NSPoint(x: leftX, y: topY - h * 0.13),
               controlPoint1: NSPoint(x: cx - w * 0.13, y: botY + h * 0.15),
               controlPoint2: NSPoint(x: leftX, y: cy + h * 0.03))

    path.curve(to: NSPoint(x: cx, y: topY),
               controlPoint1: NSPoint(x: leftX, y: topY),
               controlPoint2: NSPoint(x: cx - w * 0.38, y: topY))

    path.close()
    return path
}

func renderIcon(size: CGFloat) -> NSImage {
    let img = NSImage(size: NSSize(width: size, height: size))
    img.lockFocus()

    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let cr = size * 0.223

    // --- Background ---
    let bgPath = NSBezierPath(roundedRect: rect, xRadius: cr, yRadius: cr)

    let c1 = NSColor(red: 0.055, green: 0.063, blue: 0.098, alpha: 1.0)  // #0E1019
    let c2 = NSColor(red: 0.094, green: 0.063, blue: 0.169, alpha: 1.0)  // #18102B
    NSGradient(starting: c1, ending: c2)?.draw(in: bgPath, angle: -90)

    // subtle radial glow behind shield
    let glowRect = NSRect(x: size * 0.15, y: size * 0.1, width: size * 0.7, height: size * 0.6)
    let glowC1 = NSColor(red: 0.0, green: 0.45, blue: 0.72, alpha: 0.12)
    let glowC2 = NSColor(red: 0.0, green: 0.45, blue: 0.72, alpha: 0.0)
    NSGradient(starting: glowC1, ending: glowC2)?
        .draw(in: NSBezierPath(ovalIn: glowRect), relativeCenterPosition: NSPoint(x: 0, y: 0.2))

    // --- Inner border ---
    let inset = rect.insetBy(dx: size * 0.004, dy: size * 0.004)
    let borderPath = NSBezierPath(roundedRect: inset, xRadius: cr - size * 0.004, yRadius: cr - size * 0.004)
    NSColor(white: 1.0, alpha: 0.06).setStroke()
    borderPath.lineWidth = size * 0.003
    borderPath.stroke()

    // --- Shield ---
    let shieldMargin = size * 0.21
    let shieldRect = NSRect(
        x: shieldMargin,
        y: shieldMargin * 0.75,
        width: size - shieldMargin * 2,
        height: size - shieldMargin * 1.65
    )
    let shield = shieldPath(in: shieldRect)

    // Shield shadow
    let ctx = NSGraphicsContext.current!.cgContext
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -size * 0.01),
                  blur: size * 0.06,
                  color: NSColor(red: 0.0, green: 0.6, blue: 0.9, alpha: 0.35).cgColor)
    NSColor.white.withAlphaComponent(0.0).setFill()
    shield.fill()
    ctx.restoreGState()

    // Shield gradient fill
    ctx.saveGState()
    shield.addClip()

    let sC1 = NSColor(white: 1.0, alpha: 0.95)
    let sC2 = NSColor(white: 0.88, alpha: 0.92)
    NSGradient(starting: sC1, ending: sC2)?.draw(in: shieldRect, angle: -90)

    // Accent stripe - thin teal line across upper third
    let stripeY = shieldRect.maxY - shieldRect.height * 0.32
    let stripeH = shieldRect.height * 0.005
    let stripeRect = NSRect(x: shieldRect.minX, y: stripeY, width: shieldRect.width, height: stripeH)
    NSColor(red: 0.0, green: 0.78, blue: 0.92, alpha: 0.5).setFill()
    NSBezierPath(rect: stripeRect).fill()

    ctx.restoreGState()

    // Shield outline
    NSColor(white: 1.0, alpha: 0.15).setStroke()
    shield.lineWidth = size * 0.004
    shield.stroke()

    // --- Bottom glow accent ---
    let accentRect = NSRect(x: size * 0.3, y: size * 0.05, width: size * 0.4, height: size * 0.22)
    let aC1 = NSColor(red: 0.0, green: 0.82, blue: 1.0, alpha: 0.18)
    let aC2 = NSColor(red: 0.0, green: 0.82, blue: 1.0, alpha: 0.0)
    NSGradient(starting: aC1, ending: aC2)?
        .draw(in: NSBezierPath(ovalIn: accentRect), relativeCenterPosition: NSPoint(x: 0, y: 0))

    img.unlockFocus()
    return img
}

func savePNG(_ image: NSImage, to path: String) {
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:]) else {
        print("Error creating PNG")
        exit(1)
    }
    try! png.write(to: URL(fileURLWithPath: path))
}

// --- Main ---

guard CommandLine.arguments.count > 1 else {
    print("Usage: generate-icon <output-dir>")
    exit(1)
}

let outputDir = CommandLine.arguments[1]
let iconsetDir = outputDir + "/AppIcon.iconset"

try? FileManager.default.createDirectory(atPath: iconsetDir,
                                         withIntermediateDirectories: true)

let sizes: [(String, CGFloat)] = [
    ("icon_16x16.png",      16),
    ("icon_16x16@2x.png",   32),
    ("icon_32x32.png",      32),
    ("icon_32x32@2x.png",   64),
    ("icon_128x128.png",    128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png",    256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png",    512),
    ("icon_512x512@2x.png", 1024),
]

print("Generating app icon...")
let master = renderIcon(size: 1024)

for (name, px) in sizes {
    let resized = NSImage(size: NSSize(width: px, height: px))
    resized.lockFocus()
    master.draw(in: NSRect(x: 0, y: 0, width: px, height: px),
                from: NSRect(x: 0, y: 0, width: 1024, height: 1024),
                operation: .copy, fraction: 1.0)
    resized.unlockFocus()
    savePNG(resized, to: iconsetDir + "/" + name)
}

print("Converting to .icns...")
let proc = Process()
proc.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
proc.arguments = ["-c", "icns", iconsetDir, "-o", outputDir + "/AppIcon.icns"]
try! proc.run()
proc.waitUntilExit()

if proc.terminationStatus == 0 {
    try? FileManager.default.removeItem(atPath: iconsetDir)
    print("✅ AppIcon.icns generated")
} else {
    print("⚠️  iconutil failed (status \(proc.terminationStatus))")
    exit(1)
}
