# Psaltir — project guide for Claude

The 150 Psalms of David in **Serbian (Cyrillic)** and **English**, for Orthodox liturgical use: numbering and verse divisions follow the Septuagint (LXX) tradition.

**This repo is mid-conversion.** The app used to be a React/Vite/Capacitor web app wrapped for iOS. It is being converted to a **native SwiftUI, iPhone-only app** (no Capacitor, no WebView, no Android). The native app lives under `ios/App/App/` and is now the primary target — read that section first. The original web app under `src/`, `android/`, and the root Vite/Capacitor config files (`index.html`, `vite.config.js`, `tailwind.config.js`, `postcss.config.js`, `package.json`, `capacitor.config.json`) are **kept only as a reference/parity check** during the transition and are slated for deletion once the native app has been reviewed and built successfully in Xcode — don't add new features to them.

## Native iOS app (`ios/App/App/`)

| | |
|---|---|
| Stack | Swift, SwiftUI, iOS 15+. No third-party deps, no Capacitor, no WebView. iPhone only (`TARGETED_DEVICE_FAMILY = 1`). |
| Entry point | `PsaltirApp.swift` (`@main`) → `ContentView` |
| State shape | `ContentView` holds `@State selected: Int?` (psalm number or nil) and `@State fontSize: CGFloat`. When `selected == nil` show `PsalmListView`, otherwise `PsalmReaderView`. Same shape as the old `App.jsx`. |
| i18n | `LanguageManager` (`ObservableObject`, injected as an `@EnvironmentObject`). `language` is `.sr` or `.en`, persisted to `UserDefaults` under key `"psalter-lang"` (same key the web app used for `localStorage`, unrelated storage). Exposes `t` (`AppStrings`), `pocetak`, `napomene`, `puniTekst` — same shape as the old `useLanguage()`. |
| Build | Open `ios/App/App.xcodeproj` in Xcode and run. **This repo has no macOS/Xcode toolchain available in the sandbox that built it** — the project file was hand-authored/edited as text and has *not* been compiled or run. Treat the first real Xcode open as the real first build; expect to fix small issues (a stray build-file reference, an asset name mismatch) that only Xcode's own project inspector would have caught. |

### Data model

Mirrors the old `src/data/` structure, transcribed 1:1 (verse text and verse counts are unchanged) into Swift under `ios/App/App/Data/`:

```
ios/App/App/Data/
├── Katizme.swift        # 20 katizma groupings — [Katizma(broj:opseg:psalmi:)]
├── PocetakSr.swift      # SR opening lines, [Int: String], all 150
├── PocetakEn.swift      # EN opening lines, [Int: String], all 150 (still KJV-remapped, see Open work)
├── NapomeneSr.swift     # SR liturgical notes, [Int: String], ~30 entries
├── NapomeneEn.swift     # EN liturgical notes, [Int: String], ~30 entries (parity with SR)
├── PuniTekstSr.swift    # SR full verse-by-verse text, [Int: [String]], 23 psalms
└── PuniTekstEn.swift    # EN full text — Brenton's Septuagint, [Int: [String]], 23 psalms
```

These were generated mechanically from the JS source (via a Node script that imported the ES modules and dumped JSON, then a Python script that emitted Swift dictionary literals) rather than hand-typed, specifically to avoid transcription errors across ~1700 lines of Cyrillic/English verse text. If you need to regenerate them (e.g. after adding more psalms to the web-side data first), the same approach is the fastest safe path — do not hand-retype verse text.

Each `PuniTekst*.swift` is `[Int: [String]]`: one verse per array entry, position = verse number − 1, no inscription (same convention as the web app — see "Decision history" below).

### Views (`ios/App/App/Views/`)

```
OrnamentView.swift        # decorative diamond ornament, drawn with Canvas/Path (ports the inline SVG)
DividerView.swift         # horizontal divider with center ornament
PsalmListItemView.swift   # single row in the list view
PsalmListView.swift       # search + katizma filter + scrollable list + header/footer + language toggle
PsalmReaderView.swift     # full-text reader with drop cap, font controls, prev/next navigation
ContentView.swift         # root view, holds `selected` and `fontSize`
```

`PsalmListView` builds its `allPsalms` array fresh from `lang.pocetak`/`lang.puniTekst` (computed property, not cached) — same "always fresh" behavior as the React version's `useMemo`. `PsalmReaderView` falls back to a "not yet available" panel when `lang.puniTekst[broj]` is nil.

`Theme.swift` (`ios/App/App/Extensions/`) holds hardcoded Color constants approximating the web app's Tailwind amber/stone/red palette, plus `Theme.display()`/`Theme.serif()` font helpers. **Those font helpers currently return system serif-design fonts, not the actual Cormorant Garamond / EB Garamond faces** the web app used — see Open work below.

### Known simplifications vs. the web app

- **Fonts**: using `.system(design: .serif)` instead of the real Cormorant Garamond (display) / EB Garamond (body) faces. The web app loaded these from Google Fonts; the native app needs the actual `.ttf`/`.otf` files bundled and registered via `Info.plist`'s `UIAppFonts` key. Not done yet.
- **Drop cap**: the web reader used a CSS float so body text wrapped around the oversized first letter. SwiftUI has no direct equivalent, so `PsalmReaderView` renders the drop cap and the rest of verse 1 side-by-side in an `HStack` instead — visually close but not a true wrap.
- **App Icon / Splash**: still the original Capacitor default placeholders (blue ✕ on grid), untouched by this conversion. Must be replaced before any TestFlight/App Store submission.
- **No router**: same as the web app — `selected` is transient `@State`, so backgrounding/relaunching the app returns to the list. That's intentional, matching the original no-router decision.

## Legacy web app (`src/`, `android/`) — reference only, pending deletion

The original React 18 + Vite + Tailwind + Capacitor app. Kept temporarily so the native rewrite can be checked against it line-by-line; do not extend it. Its own historical documentation:

| | |
|---|---|
| Stack | React 18, Vite 5, Tailwind 3, lucide-react. No router. No tests. |
| Entry point | `src/main.jsx` → `<App />` (`src/App.jsx`) |
| i18n | `src/i18n/LanguageContext.jsx`, same `T` object the native `AppStrings.swift` was transcribed from. |
| Data | `src/data/*.js` + `src/data/en/*.js` — the source the native `Data/*.swift` files were generated from. |
| Components | `src/components/*.jsx` — the source the native `Views/*.swift` files were ported from. |

### The two translations and the LXX vs MT numbering question

**Serbian** is Bishop Atanasije (Jevtić)'s translation from Church Slavonic and Greek (Septuagint). Sourced from molitvenik.in.rs.

**English** is **Brenton's English Septuagint (1851, public domain)**, sourced from `https://ebible.org/eng-Brenton/PSAnnn.htm`.

Both translations use **LXX/Orthodox numbering**:

| LXX (this app) | KJV/MT |
|---|---|
| Ps 1–8 | Ps 1–8 |
| Ps 9 | Ps 9 + Ps 10 (LXX keeps one acrostic; MT splits it) |
| Ps 10–112 | Ps 11–113 (off by one through the middle) |
| Ps 113 | Ps 114 + Ps 115 (LXX merges) |
| Ps 114 + Ps 115 | Ps 116 (LXX splits) |
| Ps 116–145 | Ps 117–146 (off by one again) |
| Ps 146 + Ps 147 | Ps 147 (LXX splits) |
| Ps 148–150 | Ps 148–150 |

If you ever need to reference a KJV Bible, this matters. Brenton handles it natively; KJV does not.

Inscriptions ("A Psalm of David…") are **not numbered** in the data files. Brenton numbers them as verses 1 (or 1–2) in the source; the fetcher script strips them so the body starts at array index 0 = verse 1 in display. This convention carries over unchanged into the native `PuniTekst*.swift` files.

### Tooling: Brenton fetcher

`/tmp/brenton_fetch.py` (not checked into the repo) is the script that fetched and parsed Brenton's psalms from ebible.org. Notable quirks it handles:

- Verse markers can sit in `<div class='d'>` (inscription) but the body continues in the following `<div class='p'>`. The parser tracks `current_verse` across div boundaries but only buffers text while inside a 'p' div, then drops verses with empty body (pure inscriptions).
- Footnote anchors (`<a class="notemark">`) have nested `<span class="popup">` tooltip text that must be skipped along with the asterisk marker.
- Italicized translator additions (`<span class='add'>`) and small-caps spans are unwrapped (text kept, markup dropped).

To re-run for additional psalms, edit the `PSALMS` list at the top of the script and re-run. The output is a JS module that drops into `src/data/en/puniTekst.js` — and, since the native data files are generated from the JS source (see above), should be re-transcribed into `PuniTekstEn.swift` afterward.

## Open work

### Done in the most recent session
- **Converted the app to native SwiftUI, iPhone-only** (see top of this file). Added `ios/App/App/{PsaltirApp,Views,Models,Data,Extensions}` with a full port of the list view, reader, i18n, and all psalm data (150 opening lines × 2 languages, 23 full-text psalms × 2 languages, 30 liturgical notes × 2 languages, 20 katizme). Removed the Capacitor/WebView plumbing from the `ios/App` Xcode project (AppDelegate, Main.storyboard, the `CapApp-SPM` Swift package dependency) and restricted the target to iPhone only.
- Left `src/`, `android/`, and the root Vite/Capacitor config files in place as a reference during the transition (see "Legacy web app" above) — **delete these once the native app has been opened and built successfully in Xcode.**
- Previously (prior session): switched English full text from KJV to **Brenton's English Septuagint** for the 23 existing psalms (1–8, 46, 50, 85, 89, 90, 101–103, 134, 136, 140, 142, 148–150).

### Highest-priority remaining work

1. **Open `ios/App/App.xcodeproj` in real Xcode and fix whatever the first build surfaces.** This project was authored/edited as text without access to Xcode or a Swift toolchain — treat the pbxproj and Swift sources as unverified until a real build succeeds.
2. **Delete the legacy web app** (`src/`, `android/`, `index.html`, `vite.config.js`, `tailwind.config.js`, `postcss.config.js`, `package.json`, `package-lock.json`, `capacitor.config.json`) once the native app is confirmed working, and update `README.md` accordingly.
3. **Bundle the real Cormorant Garamond / EB Garamond fonts** and wire them up via `Info.plist`'s `UIAppFonts`, replacing the `Theme.display()`/`Theme.serif()` system-font stand-ins.
4. **Fill in the remaining 127 psalms** in both languages (currently 23/150 have full text) — same source material as before (molitvenik.in.rs for SR, extending the Brenton fetcher for EN), transcribed into `PuniTekstSr.swift`/`PuniTekstEn.swift`. Pay attention at LXX 9, 113, 114, 115, 146, 147 — the LXX/MT split boundaries.
5. **Regenerate `PocetakEn.swift`** from Brenton opening lines (currently KJV-remapped — safe but inconsistent with the Brenton attribution in the footer).
6. **iOS App Icon and Splash** — replace the Capacitor-era placeholders before any TestFlight/App Store submission. Needs design input.

### Secondary polish
- No CI workflow. A GitHub Actions lane that runs `xcodebuild` (once a Mac runner or self-hosted macOS is available) would catch build regressions.
- No tests. Consider a small XCTest/XCUITest smoke test (list renders, language toggle works, font controls clamp) once the app builds.

## Conventions and small things

- Serbian display uses Cyrillic exclusively. Don't transliterate.
- Brenton uses "Pause." where KJV uses "Selah." — keep as-is.
- The reader's drop cap uses the first character of verse 1 (`stih.first`). If verse 1 starts with punctuation or a digit this will look wrong; verify when adding new psalms.
- The font-size range is clamped `[14, 28]` in `PsalmReaderView.swift`. Don't add a slider without adjusting bounds in both call sites (the two buttons).
- When you add a new UI string, add it to **both** `AppStrings.sr` and `AppStrings.en` in `Strings.swift` — there's no fallback.

## Decision history

- **2026-09**: Converted from React/Vite/Capacitor web app (wrapped for iOS + Android) to a native SwiftUI, iPhone-only app. Reason: user requested Xcode/iPhone-only distribution with no web/WebView layer. The web app and Android wrapper are kept temporarily for reference and will be deleted once the native app builds successfully.
- **2026-06**: English translation switched from KJV (with manual LXX renumber) → Brenton's Septuagint (1851). Reason: at the LXX/MT split boundaries (Ps 9, 113, 114, 115, 146, 147) the KJV remap is unfixable — KJV's verse divisions don't carve up the same way LXX does. Brenton translates directly from the Greek the Orthodox tradition uses, so verse numbers and divisions match Atanasije natively.
- **2026-06**: Confirmed inscriptions ("A Psalm of David…") are dropped from the verse arrays — matching the Atanasije source convention and avoiding awkward verse-1 content.
