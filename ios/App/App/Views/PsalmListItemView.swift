import SwiftUI

/// A single row in the list view — ports PsalmListItem.jsx.
struct PsalmListItemView: View {
    let broj: Int
    let opening: String
    let hasFull: Bool
    let t: AppStrings
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .firstTextBaseline, spacing: 16) {
                Text("\(broj)")
                    .font(Theme.display(26, weight: .semibold))
                    .foregroundColor(Theme.amber900)
                    .frame(width: 48, alignment: .trailing)

                VStack(alignment: .leading, spacing: 4) {
                    Text(opening + "…")
                        .font(Theme.serif(16))
                        .foregroundColor(Theme.stone800)
                        .lineLimit(2)
                    if !hasFull {
                        Text(t.openingVerse)
                            .font(Theme.serif(12))
                            .italic()
                            .foregroundColor(Theme.stone500)
                    }
                }

                Spacer(minLength: 0)

                Text("›")
                    .font(.system(size: 24))
                    .foregroundColor(Theme.amber900.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PsalmRowButtonStyle())
        .overlay(
            Rectangle()
                .fill(Theme.amber900.opacity(0.15))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

/// Gives the row a subtle highlight while pressed, matching the web
/// hover/active background tint.
private struct PsalmRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Theme.amber100.opacity(0.6) : Color.clear)
    }
}
