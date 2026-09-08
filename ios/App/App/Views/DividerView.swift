import SwiftUI

/// Horizontal rule with a centered ornament — ports Divider.jsx.
struct DividerView: View {
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Theme.amber900.opacity(0.3))
                .frame(height: 1)
                .frame(maxWidth: 120)
            OrnamentView(size: 18)
            Rectangle()
                .fill(Theme.amber900.opacity(0.3))
                .frame(height: 1)
                .frame(maxWidth: 120)
        }
        .padding(.vertical, 32)
    }
}
