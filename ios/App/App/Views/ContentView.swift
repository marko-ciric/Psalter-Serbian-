import SwiftUI

/// Root view — ports App.jsx. Holds the two pieces of state that used to
/// live in App.jsx: which psalm is selected (nil = show the list) and the
/// reader's font size, which survives back/forward navigation.
struct ContentView: View {
    @StateObject private var lang = LanguageManager()
    @State private var selected: Int? = nil
    @State private var fontSize: CGFloat = 18

    var body: some View {
        Group {
            if let broj = selected {
                PsalmReaderView(
                    broj: broj,
                    fontSize: $fontSize,
                    onBack: { selected = nil },
                    onNavigate: { selected = $0 }
                )
            } else {
                PsalmListView(onSelect: { selected = $0 })
            }
        }
        .environmentObject(lang)
        .animation(.default, value: selected)
    }
}
