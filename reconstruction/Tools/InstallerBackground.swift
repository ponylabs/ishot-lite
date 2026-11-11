import AppKit
let width = 640.0, height = 400.0
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 1280, pixelsHigh: 800, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
NSGraphicsContext.current!.cgContext.scaleBy(x: 2, y: 2)
NSGradient(starting: NSColor(calibratedRed: 0.97, green: 0.98, blue: 1, alpha: 1), ending: NSColor.white)!.draw(in: NSRect(x: 0, y: 0, width: width, height: height), angle: 90)
func label(_ text: String, top: Double, size: Double, weight: NSFont.Weight, color: NSColor) {
    let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color]
    let bounds = (text as NSString).size(withAttributes: attrs)
    (text as NSString).draw(at: NSPoint(x: (width - bounds.width) / 2, y: height - top - bounds.height), withAttributes: attrs)
}
label("iShot Lite", top: 34, size: 29, weight: .semibold, color: NSColor(calibratedRed: 0.17, green: 0.23, blue: 0.38, alpha: 1))
label("拖入应用程序，即可安装", top: 80, size: 15, weight: .regular, color: .secondaryLabelColor)
let arrow = NSBezierPath()
arrow.move(to: NSPoint(x: 285, y: 205)); arrow.line(to: NSPoint(x: 355, y: 205))
arrow.move(to: NSPoint(x: 343, y: 217)); arrow.line(to: NSPoint(x: 355, y: 205)); arrow.line(to: NSPoint(x: 343, y: 193))
arrow.lineWidth = 3; arrow.lineCapStyle = .round; arrow.lineJoinStyle = .round
NSColor(calibratedRed: 0.38, green: 0.48, blue: 0.76, alpha: 1).setStroke(); arrow.stroke()
label("安装后，请从“应用程序”打开 iShot Lite", top: 326, size: 13, weight: .regular, color: .secondaryLabelColor)
NSGraphicsContext.restoreGraphicsState()
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
