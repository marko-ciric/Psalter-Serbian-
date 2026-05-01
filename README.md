# Псалтир Светог цара Давида

A web app of the 150 Psalms of David in Serbian (Cyrillic), based on the official Serbian Orthodox translation by Bishop Atanasije (Jevtić), translated from Church Slavonic and Greek (the Septuagint).

## Features

- All 150 psalms listed with opening verse and number
- Full text for 23 most-used Orthodox psalms (Katizma 1, the Hexapsalmos, Psalm 50, Psalm 90, the Liturgy and Vespers psalms, the closing praise psalms 148–150, etc.)
- Opening lines for the remaining psalms (full text can be added incrementally)
- Search by text or psalm number
- Filter by katizma (the 20 traditional Orthodox liturgical divisions)
- Adjustable font size in the reader
- Previous/next navigation between psalms
- Manuscript-inspired design with Cormorant Garamond and EB Garamond typography

## Tech stack

- React 18
- Vite
- Tailwind CSS
- lucide-react for icons

## Getting started

```bash
npm install
npm run dev
```

Build for production:

```bash
npm run build
```

The build output goes into `dist/` and can be served from any static host (GitHub Pages, Netlify, Vercel, Cloudflare Pages).

## Project structure

```
src/
├── main.jsx              # React entry point
├── App.jsx               # Root component, holds selected psalm state
├── index.css             # Tailwind + global styles + parchment background
├── data/
│   ├── katizme.js        # The 20 katizma groupings
│   ├── pocetak.js        # Opening line of every psalm (1–150)
│   ├── napomene.js       # Liturgical notes for important psalms
│   └── puniTekst.js      # Full verse-by-verse text (currently 23 psalms)
└── components/
    ├── Ornament.jsx
    ├── Divider.jsx
    ├── PsalmListItem.jsx
    ├── PsalmList.jsx
    └── PsalmReader.jsx
```

## Adding more psalms

To add the full text of any psalm, open `src/data/puniTekst.js` and add an entry:

```js
export const PUNI_TEKST = {
  // ...
  42: [
    "Као што чезне јелен за изворима вода...",
    "Жедна је душа моја Бога живога...",
    // one string per verse
  ],
};
```

The list view will automatically stop showing the "почетни стих" label once full text is present.

## Source

Translation by Епископ Атанасије (Јевтић), via [молитвеник.in.rs](https://www.molitvenik.in.rs/psaltir_index.html).

## License

Application code: MIT.
The Psalter text is a translation of public-domain scripture; please credit the translator (Bishop Atanasije Jevtić) when redistributing.
