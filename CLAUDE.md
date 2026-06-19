# Psaltir — project guide for Claude

A web app of the 150 Psalms of David in **Serbian (Cyrillic)** and **English**, served as a React SPA built with Vite and wrapped for iOS via Capacitor. Designed for Orthodox liturgical use: numbering and verse divisions follow the Septuagint (LXX) tradition.

## Quick orientation

| | |
|---|---|
| Stack | React 18, Vite 5, Tailwind 3, lucide-react. No router. No tests. |
| Entry point | `src/main.jsx` → `<App />` (`src/App.jsx`) |
| State shape | `App` holds two `useState`s: `selected` (psalm number or null) and `fontSize`. When `selected === null` show `PsalmList`, otherwise `PsalmReader`. |
| i18n | Single React context (`src/i18n/LanguageContext.jsx`). Language is `'sr'` or `'en'`, persisted to `localStorage` under key `psalter-lang`. The context exposes `{language, setLanguage, t, POCETAK, NAPOMENE, PUNI_TEKST}`; consumers call `useLanguage()`. UI strings live in the `T` object inside `LanguageContext.jsx`. |
| Build outputs | `npm run dev`, `npm run build` (emits `dist/`), `npm run preview`. iOS wrapper reads from `dist/` via `capacitor.config.json`. |

## Data model

All psalm content lives in plain `.js` modules under `src/data/`:

```
src/data/
├── katizme.js              # 20 katizma groupings — language-neutral. Just psalm-number arrays.
├── pocetak.js              # SR opening lines for all 150 psalms (one short fragment each)
├── napomene.js             # SR liturgical notes for ~30 important psalms
├── puniTekst.js            # SR full verse-by-verse text — Daničić's Septuagint Psalter, all 150 psalms.
└── en/
    ├── pocetak.js          # EN opening lines (150) — Brenton-derived fragments.
    ├── napomene.js         # EN liturgical notes (parity with SR, 30 entries).
    └── puniTekst.js        # EN full text — Brenton's Septuagint, all 150 psalms.
```

Each `puniTekst.js` exports an object keyed by psalm number; the value is an array of verse strings (one per verse, position = verse number − 1, no inscription).

```js
export const PUNI_TEKST = {
  1: ['Blessed is the man...', 'But his pleasure is in the law...', ...],
  // ...
};
```

`pocetak.js` exports `POCETAK` as a `{number: string}` map. The list view shows the opening line as a preview; the reader uses it as a fallback when no full text is available.

`napomene.js` exports `NAPOMENE` as a sparse `{number: string}` map. Shown in italics above the reader.

`katizme.js` exports `KATIZME = [{ broj, psalmi: [...] }, ...]` — used for filter chips on the list view. Names are not localized (they're numbers).

## Components

```
src/components/
├── Ornament.jsx         # decorative SVG ornament
├── Divider.jsx          # horizontal divider with center ornament
├── PsalmListItem.jsx    # single row in the list view
├── PsalmList.jsx        # search + katizma filter + scrollable list
└── PsalmReader.jsx      # full-text reader with drop cap, font controls, prev/next
```

`PsalmList` reads `KATIZME` directly from `data/katizme.js` and pulls `POCETAK`/`PUNI_TEKST`/`t` from `useLanguage()`. It builds the `allPsalms` array fresh each render based on the language-active POCETAK/PUNI_TEKST. `PsalmReader` does the same and falls back to a "not yet available" panel when `PUNI_TEKST[broj]` is undefined.

The font-size state lives in `App` (not `PsalmReader`) so it survives back/forward navigation.

## The two translations and the LXX vs MT numbering question

**Serbian** is **Đuro Daničić's Serbian Psalter (1860s, public domain)**, translated from Church Slavonic/the Septuagint with native LXX numbering. This replaced an earlier partial (23-psalm) modern translation by Bishop Atanasije (Jevtić), sourced from molitvenik.in.rs — see decision history below for why.

**English** is **Brenton's English Septuagint (1851, public domain)**, sourced from `https://ebible.org/eng-Brenton/PSAnnn.htm`. This was switched from KJV in an earlier session.

Both translations are public domain (translators died well over a century ago), which matters for an app distributed on the App Store with no other licensing in place.

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

Inscriptions ("A Psalm of David…") are **not numbered** in the data files. Brenton numbers them as verses 1 (or 1–2) in the source; the fetcher script strips them so the body starts at array index 0 = verse 1 in display.

## Tooling: Brenton fetcher

`/tmp/brenton_fetch.py` (not checked into the repo) is the script that fetched and parsed Brenton's psalms from ebible.org. Notable quirks it handles:

- Verse markers can sit in `<div class='d'>` (inscription) but the body continues in the following `<div class='p'>`. The parser tracks `current_verse` across div boundaries but only buffers text while inside a 'p' div, then drops verses with empty body (pure inscriptions).
- Footnote anchors (`<a class="notemark">`) have nested `<span class="popup">` tooltip text that must be skipped along with the asterisk marker.
- Italicized translator additions (`<span class='add'>`) and small-caps spans are unwrapped (text kept, markup dropped).

To re-run for additional psalms, edit the `PSALMS` list at the top of the script and re-run. The output is a JS module that drops into `src/data/en/puniTekst.js`.

## Tooling: Daničić verse segmentation

The source text for Daničić's Psalter (obtained as a single plain-text paste, not scraped) has **no verse markers** — each psalm is continuous prose, with liturgical `Катизма N.` (kathisma) and `С л а в а:` (Gloria) markers interspersed, plus the occasional explanatory footnote in parentheses. To produce the verse arrays in `src/data/puniTekst.js`:

1. Split on `Псалам N.` headers; strip kathisma/Gloria/`Средина:` marker lines and parenthetical footnote paragraphs.
2. Split each psalm's remaining prose into sentences on `.`/`!`/`?`.
3. Use the **English Brenton verse count** for that psalm number (`src/data/en/puniTekst.js`, both translations share LXX numbering so verse counts should match) as the target count, then mechanically merge adjacent sentences (if there are too many) or split sentences at `;`/`:`/`,` (if there are too few) until the count matches.

This produces the *correct verse count* per psalm but verse **boundaries are not manually verified against the Greek/Brenton** — for liturgical use where exact verse-by-verse parallel reading matters, spot-check important psalms before relying on a specific verse number.

## Languages, UI strings, fallback

UI translation strings are defined inline in `LanguageContext.jsx`'s `T` object. When you add a new UI string, add it to **both** `T.sr` and `T.en` — there's no fallback; a missing key returns `undefined`.

When a psalm has no full text (most of them), `PsalmReader` shows the opening verse from `POCETAK` inside a quote-formatted panel plus a friendly "full text will be added" message.

## iOS / Capacitor

`capacitor.config.json` declares `appId: rs.psalter.app`, `appName: Псалтир`, `webDir: dist`. The Xcode project under `ios/App/` is standard Capacitor. **Note**: the App Icon and Splash assets are currently the **default Capacitor placeholders** (blue ✕ on grid) — must be replaced before any App Store submission.

`Info.plist` sets `CFBundleDisplayName` to "Псалтир".

## Open work

### Done in the most recent session
- English full text (Brenton's Septuagint) completed for all 150 psalms in `src/data/en/puniTekst.js`.
- `src/data/en/pocetak.js` swapped from KJV-remapped to Brenton-derived opening lines for all 150 psalms.
- **Serbian full text replaced entirely**: all 150 psalms in `src/data/puniTekst.js` now use Đuro Daničić's public-domain, LXX-numbered Psalter (replacing the previous 23-psalm partial Atanasije translation). Source text was supplied directly by the user (continuous prose, no verse markers) and mechanically segmented into verses using the English Brenton verse counts as targets — see "Tooling: Daničić verse segmentation" above. Verse counts now match the English file exactly for all 150 psalms; verse *boundaries* are not all manually spot-checked.
- `npm run build` clean; spot-checked Psalms 1, 8, 50 in the live app (Serbian) for correct verse counts and rendering.

### Highest-priority remaining work

1. **Spot-check / correct verse boundaries** in the new Daničić `puniTekst.js`. The segmentation algorithm guarantees the right *count* per psalm but the split points (especially where it merged or split mid-sentence at semicolons) were not individually verified against the Greek. Important/frequently-read psalms (1, 50, 90, 103, 118, 140, 150) are good candidates to check first.

2. **iOS App Icon and Splash** — replace Capacitor placeholders before any TestFlight/App Store submission. Needs design input.

### Secondary polish
- No CI workflow. A GitHub Pages or Cloudflare Pages deploy action would be a small add.
- No ESLint/Prettier config. Standard React+Vite ESLint would be a small add.
- No tests. The app is data-driven so a single smoke test (renders, language toggle works, font controls clamp) would catch most regressions.

## Conventions and small things

- All text is rendered with React's default escaping — strings can contain `"`, `'`, `—`, etc. without special handling.
- Serbian display uses Cyrillic exclusively. Don't transliterate.
- Brenton uses "Pause." where KJV uses "Selah." — keep as-is.
- The reader's drop cap is the literal first character of verse 1, sliced via `stih.charAt(0)`. If verse 1 starts with punctuation or a digit this will look wrong; verify when adding new psalms.
- The font-size range is clamped `[14, 28]` in `PsalmReader.jsx`. Don't add a slider without adjusting bounds in both call sites.
- All routes are in-memory; refreshing the browser drops you back to the list view. That's intentional given the no-router decision.

## Decision history

- **2026-06**: English translation switched from KJV (with manual LXX renumber) → Brenton's Septuagint (1851). Reason: at the LXX/MT split boundaries (Ps 9, 113, 114, 115, 146, 147) the KJV remap is unfixable — KJV's verse divisions don't carve up the same way LXX does. Brenton translates directly from the Greek the Orthodox tradition uses, so verse numbers and divisions match Atanasije natively.
- **2026-06**: Confirmed inscriptions ("A Psalm of David…") are dropped from the verse arrays — matching the Atanasije source convention and avoiding awkward verse-1 content.
- **2026-06**: Serbian translation switched from Bishop Atanasije (Jevtić)'s modern translation (23/150 psalms, sourced from molitvenik.in.rs, copyright status unclear) → Đuro Daničić's 1860s Septuagint-numbered Serbian Psalter (all 150 psalms, public domain — translator died 1882). Reason: full-Psalter coverage from a single, unambiguously public-domain, LXX-numbered source, mirroring the same consistency rationale as the English KJV→Brenton switch. Note: the *commonly available* digitized "Daničić" text (e.g. on GitHub as part of the Daničić–Karadžić Bible) is a **later revision that renumbers the Psalms to Hebrew/Masoretic numbering** for Protestant Bible convention — that version is NOT usable here. The original LXX-numbered translation was sourced as a direct text paste (not fetched programmatically) after `svetosavlje.org`, `rastko.rs`, and `sr.wikisource.org` all proved unreachable from the sandbox (network allowlist / bot protection).
