# Псалтир Светог цара Давида

The 150 Psalms of David in Serbian (Cyrillic), based on the official Serbian Orthodox translation by Bishop Atanasije (Jevtić), translated from Church Slavonic and Greek (the Septuagint) — plus an English translation from Brenton's English Septuagint (1851).

**This repo is mid-conversion** from a React/Vite/Capacitor web app to a **native SwiftUI, iPhone-only app**. See `CLAUDE.md` for the full status. The native app is now the primary target; the original web app is kept temporarily for reference and will be removed.

## Native iOS app

```
ios/App/App.xcodeproj
```

Open in Xcode (15+, iOS 15+ deployment target) and run. Swift/SwiftUI, no third-party dependencies, no WebView.

```
ios/App/App/
├── PsaltirApp.swift    # @main entry point
├── Views/              # ContentView, PsalmListView, PsalmReaderView, etc.
├── Models/             # AppStrings (i18n copy), LanguageManager
├── Data/               # Katizme, PocetakSr/En, NapomeneSr/En, PuniTekstSr/En
└── Extensions/         # Theme.swift (colors, font helpers)
```

## Features

- All 150 psalms listed with opening verse and number
- Full text for 23 most-used Orthodox psalms (Katizma 1, the Hexapsalmos, Psalm 50, Psalm 90, the Liturgy and Vespers psalms, the closing praise psalms 148–150, etc.)
- Opening lines for the remaining psalms (full text can be added incrementally)
- Search by text or psalm number
- Filter by katizma (the 20 traditional Orthodox liturgical divisions)
- Adjustable font size in the reader
- Previous/next navigation between psalms
- Serbian (Atanasije Jevtić) and English (Brenton's Septuagint) translations, switchable in-app

## Legacy web app (reference only)

`src/`, `android/`, and the root Vite/Capacitor config files are the original React implementation this native app was ported from. Not maintained going forward — see `CLAUDE.md`'s "Open work" for the plan to remove them.

## Source

- Serbian translation by Епископ Атанасије (Јевтић), via [молитвеник.in.rs](https://www.molitvenik.in.rs/psaltir_index.html).
- English translation: Brenton's English Septuagint (1851, public domain), via [ebible.org](https://ebible.org/eng-Brenton/).

## License

Application code: MIT.
The Psalter text is a translation of public-domain scripture; please credit the translator (Bishop Atanasije Jevtić) when redistributing the Serbian text.
