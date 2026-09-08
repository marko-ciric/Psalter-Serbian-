import SwiftUI

/// Full-text reader with drop cap, font controls, and prev/next
/// navigation — ports PsalmReader.jsx.
struct PsalmReaderView: View {
    @EnvironmentObject var lang: LanguageManager
    let broj: Int
    @Binding var fontSize: CGFloat
    let onBack: () -> Void
    let onNavigate: (Int) -> Void

    var body: some View {
        let t = lang.t
        let stihovi = lang.puniTekst[broj]
        let napomena = lang.napomene[broj]

        ScrollView {
            VStack(spacing: 0) {
                topBar(t)

                VStack(spacing: 0) {
                    Text(t.psalm)
                        .font(Theme.serif(11))
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(Theme.amber900.opacity(0.7))

                    Text("\(broj)")
                        .font(Theme.display(64, weight: .bold))
                        .foregroundColor(Theme.amber900)
                        .padding(.top, 4)

                    DividerView()

                    if let napomena = napomena {
                        Text(napomena)
                            .font(Theme.serif(14))
                            .italic()
                            .foregroundColor(Theme.stone600)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                    }

                    if let stihovi = stihovi {
                        fullText(stihovi)
                    } else {
                        noFullText(t)
                    }

                    DividerView()

                    Text(t.glory)
                        .font(Theme.display(17))
                        .italic()
                        .foregroundColor(Theme.amber900.opacity(0.8))
                        .multilineTextAlignment(.center)

                    navigation(t)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
            }
        }
        .background(Theme.parchment.ignoresSafeArea())
        .id(broj) // reset scroll position when navigating between psalms
    }

    @ViewBuilder
    private func topBar(_ t: AppStrings) -> some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text(t.back).font(Theme.serif(16))
                }
                .foregroundColor(Theme.amber900)
            }
            Spacer()
            HStack(spacing: 4) {
                Button(action: { fontSize = max(14, fontSize - 2) }) {
                    Image(systemName: "minus")
                        .foregroundColor(Theme.amber900)
                }
                .accessibilityLabel(t.smallerFont)
                Image(systemName: "textformat.size")
                    .foregroundColor(Theme.amber900.opacity(0.6))
                Button(action: { fontSize = min(28, fontSize + 2) }) {
                    Image(systemName: "plus")
                        .foregroundColor(Theme.amber900)
                }
                .accessibilityLabel(t.largerFont)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Theme.stone50.opacity(0.95))
        .overlay(Rectangle().fill(Theme.amber900.opacity(0.15)).frame(height: 1), alignment: .bottom)
    }

    @ViewBuilder
    private func fullText(_ stihovi: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(stihovi.enumerated()), id: \.offset) { i, stih in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(i + 1)")
                        .font(Theme.display(13, weight: .semibold))
                        .foregroundColor(Theme.amber900.opacity(0.7))
                        .frame(width: 20, alignment: .trailing)

                    if i == 0, let first = stih.first {
                        // Approximates the web reader's CSS-floated drop cap:
                        // the first character rendered large beside the rest
                        // of the verse (not a true text-wrap float).
                        HStack(alignment: .top, spacing: 2) {
                            Text(String(first))
                                .font(Theme.display(44, weight: .bold))
                                .foregroundColor(Theme.red900)
                            Text(String(stih.dropFirst()))
                                .font(.system(size: fontSize, design: .serif))
                                .foregroundColor(Theme.stone800)
                                .lineSpacing(fontSize * 0.4)
                        }
                    } else {
                        Text(stih)
                            .font(.system(size: fontSize, design: .serif))
                            .foregroundColor(Theme.stone800)
                            .lineSpacing(fontSize * 0.4)
                    }
                }
            }
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func noFullText(_ t: AppStrings) -> some View {
        VStack(spacing: 0) {
            Text("\(t.openQuote)\(lang.pocetak[broj] ?? "")…\"")
                .font(.system(size: fontSize, design: .serif))
                .italic()
                .foregroundColor(Theme.stone700)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)

            DividerView()

            VStack {
                Text(t.noFullText1 + "\n" + t.noFullText2)
                    .font(Theme.serif(14))
                    .italic()
                    .foregroundColor(Theme.stone700)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Theme.amber50.opacity(0.7))
            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Theme.amber900.opacity(0.2), lineWidth: 1))
        }
    }

    @ViewBuilder
    private func navigation(_ t: AppStrings) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if broj > 1 {
                navButton(label: "← \(t.psalm) \(broj - 1)", opening: lang.pocetak[broj - 1] ?? "", isLeading: true) {
                    onNavigate(broj - 1)
                }
            } else {
                Spacer()
            }
            if broj < 150 {
                navButton(label: "\(t.psalm) \(broj + 1) →", opening: lang.pocetak[broj + 1] ?? "", isLeading: false) {
                    onNavigate(broj + 1)
                }
            } else {
                Spacer()
            }
        }
        .padding(.top, 48)
    }

    private func navButton(label: String, opening: String, isLeading: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: isLeading ? .leading : .trailing, spacing: 2) {
                Text(label)
                    .font(Theme.serif(12))
                    .foregroundColor(Theme.amber900.opacity(0.7))
                Text(opening + "…")
                    .font(Theme.serif(14))
                    .foregroundColor(Theme.stone700)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: isLeading ? .leading : .trailing)
            .padding(12)
            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Theme.amber900.opacity(0.25), lineWidth: 1))
        }
    }
}
