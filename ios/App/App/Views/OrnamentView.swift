import SwiftUI

/// The decorative four-pointed diamond ornament, ported from Ornament.jsx's
/// inline SVG path (viewBox 0 0 24 24) to a SwiftUI Path.
struct OrnamentView: View {
    var size: CGFloat = 24
    var color: Color = Theme.amber900

    var body: some View {
        Canvas { context, canvasSize in
            let scale = canvasSize.width / 24
            var path = Path()
            let points: [CGPoint] = [
                CGPoint(x: 12, y: 2), CGPoint(x: 13, y: 10), CGPoint(x: 21, y: 11),
                CGPoint(x: 13, y: 12), CGPoint(x: 12, y: 22), CGPoint(x: 11, y: 12),
                CGPoint(x: 3, y: 11), CGPoint(x: 11, y: 10),
            ].map { CGPoint(x: $0.x * scale, y: $0.y * scale) }
            path.addLines(points)
            path.closeSubpath()
            context.fill(path, with: .color(color))

            let dotRadius: CGFloat = 1.5 * scale
            let dotRect = CGRect(
                x: 12 * scale - dotRadius, y: 11 * scale - dotRadius,
                width: dotRadius * 2, height: dotRadius * 2
            )
            context.fill(Path(ellipseIn: dotRect), with: .color(Theme.amber50))
        }
        .frame(width: size, height: size)
        .opacity(0.7)
    }
}
