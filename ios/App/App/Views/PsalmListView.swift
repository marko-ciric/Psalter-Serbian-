import SwiftUI

private struct PsalmSummary: Identifiable {
    let broj: Int
    let opening: String
    let hasFull: Bool
    var id: Int { broj }
}

/// Search + katizma filter + scrollable list of all 150 psalms —
/// ports PsalmList.jsx.
struct PsalmListView: View {
    @EnvironmentObject var lang: LanguageManager
    let onSelect: (Int) -> Void

    @State private var search: String = ""
    @State private var activeKatizma: Int? = nil

    private var allPsalms: [PsalmSummary] {
        (1...150).map { i in
            PsalmSummary(broj: i, opening: lang.pocetak[i] ?? "", hasFull: lang.puniTekst[i] != nil)
        }
    }

    private var filtered: [PsalmSummary] {
        var list = allPsalms
        if let k = activeKatizma, let kat = katizme.first(where: { $0.broj == k }) {
            list = list.filter { kat.psalmi.contains($0.broj) }
        }
        let q = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !q.isEmpty {
            let lowerQ = q.lowercased()
            list = list.filter {
                $0.opening.lowercased().contains(lowerQ)
                    || String($0.broj) == q
                    || String($0.broj).hasPrefix(q)
            }
        }
        return list
    }

    var body: some View {
        let t = lang.t
        ScrollView {
            VStack(spacing: 0) {
                header(t)
                searchAndFilters(t)

                if filtered.isEmpty {
                    Text("\(t.noResults) „\(search)\".")
                        .font(Theme.serif(15))
                        .italic()
                        .foregroundColor(Theme.stone500)
                        .padding(.vertical, 80)
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(filtered) { p in
                            PsalmListItemView(broj: p.broj, opening: p.opening, hasFull: p.hasFull, t: t) {
                                onSelect(p.broj)
                            }
                        }
                    }
                    .background(Color.white)
                    .padding(.horizontal, 4)
                    .padding(.top, 12)
                }

                footer(t)
            }
        }
        .background(Theme.parchment.ignoresSafeArea())
    }

    @ViewBuilder
    private func header(_ t: AppStrings) -> some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                languageToggle
            }
            .padding(.trailing, 4)

            HStack(spacing: 12) {
                Rectangle().fill(Theme.amber900.opacity(0.3)).frame(width: 48, height: 1)
                OrnamentView(size: 16)
                Rectangle().fill(Theme.amber900.opacity(0.3)).frame(width: 48, height: 1)
            }

            Text(t.eyebrow)
                .font(Theme.serif(12))
                .kerning(3)
                .textCase(.uppercase)
                .foregroundColor(Theme.amber900.opacity(0.8))

            Text(t.title)
                .font(Theme.display(56, weight: .bold))
                .foregroundColor(Theme.amber900)

            Text(t.subtitle)
                .font(Theme.display(17))
                .italic()
                .foregroundColor(Theme.stone600)

            HStack(spacing: 12) {
                Rectangle().fill(Theme.amber900.opacity(0.3)).frame(width: 32, height: 1)
                Text(t.count)
                    .font(Theme.serif(11))
                    .kerning(2)
                    .textCase(.uppercase)
                    .foregroundColor(Theme.amber900.opacity(0.6))
                Rectangle().fill(Theme.amber900.opacity(0.3)).frame(width: 32, height: 1)
            }
            .padding(.top, 4)

            VStack(spacing: 4) {
                Text(t.quote)
                    .font(Theme.serif(14))
                    .italic()
                    .foregroundColor(Theme.stone600)
                Text(t.quoteAuthor)
                    .font(Theme.serif(12))
                    .foregroundColor(Theme.amber900.opacity(0.7))
            }
            .multilineTextAlignment(.center)
            .padding(.top, 12)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(Theme.amber50.opacity(0.4))
        .overlay(Rectangle().fill(Theme.amber900.opacity(0.2)).frame(height: 1), alignment: .bottom)
    }

    private var languageToggle: some View {
        HStack(spacing: 4) {
            ForEach(Language.allCases, id: \.self) { l in
                Button(action: { lang.language = l }) {
                    Text(l.rawValue.uppercased())
                        .font(Theme.serif(11))
                        .kerning(1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(lang.language == l ? Theme.amber900 : Color.white)
                        .foregroundColor(lang.language == l ? Theme.amber50 : Theme.amber900)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(lang.language == l ? Theme.amber900 : Theme.amber900.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(2)
                }
            }
        }
    }

    @ViewBuilder
    private func searchAndFilters(_ t: AppStrings) -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.amber900.opacity(0.5))
                    .font(.system(size: 14))
                TextField(t.searchPlaceholder, text: $search)
                    .font(Theme.serif(16))
                    .foregroundColor(Theme.stone800)
                if !search.isEmpty {
                    Button(action: { search = "" }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.stone500)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Theme.amber900.opacity(0.25), lineWidth: 1))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    katizmaChip(label: t.filterAll, isActive: activeKatizma == nil) {
                        activeKatizma = nil
                    }
                    ForEach(katizme, id: \.broj) { k in
                        katizmaChip(label: "\(t.filterKatizma) \(k.broj)", isActive: activeKatizma == k.broj) {
                            activeKatizma = (activeKatizma == k.broj) ? nil : k.broj
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Theme.stone50.opacity(0.95))
        .overlay(Rectangle().fill(Theme.amber900.opacity(0.15)).frame(height: 1), alignment: .bottom)
    }

    private func katizmaChip(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(Theme.serif(12))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isActive ? Theme.amber900 : Color.white)
                .foregroundColor(isActive ? Theme.amber50 : Theme.amber900)
                .overlay(
                    Capsule().stroke(isActive ? Theme.amber900 : Theme.amber900.opacity(0.3), lineWidth: 1)
                )
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private func footer(_ t: AppStrings) -> some View {
        VStack(spacing: 0) {
            DividerView()
            VStack(spacing: 2) {
                Text(t.footerLine1)
                Text(t.footerLine2)
                Text(t.footerLine3)
            }
            .font(Theme.serif(12))
            .foregroundColor(Theme.stone500)
            .multilineTextAlignment(.center)

            Text(t.alleluia)
                .font(Theme.display(15))
                .italic()
                .foregroundColor(Theme.amber900.opacity(0.7))
                .padding(.top, 16)
        }
        .padding(.horizontal, 24)
        .padding(.top, 48)
        .padding(.bottom, 40)
    }
}
