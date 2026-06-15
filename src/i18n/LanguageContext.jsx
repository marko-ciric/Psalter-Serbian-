import { createContext, useContext, useState, useMemo } from 'react'
import { POCETAK } from '../data/pocetak.js'
import { NAPOMENE } from '../data/napomene.js'
import { PUNI_TEKST } from '../data/puniTekst.js'
import { POCETAK as POCETAK_EN } from '../data/en/pocetak.js'
import { NAPOMENE as NAPOMENE_EN } from '../data/en/napomene.js'
import { PUNI_TEKST as PUNI_TEKST_EN } from '../data/en/puniTekst.js'

const T = {
  sr: {
    eyebrow: 'Светог пророка и цара',
    title: 'Псалтир',
    subtitle: 'Давидов',
    count: '150 псалама',
    quote: '„Псалтир никада не престаје"',
    quoteAuthor: '— Свети Сава Српски',
    searchPlaceholder: 'Претражи псалме (нпр. „помилуј" или 50)',
    noResults: 'Нема резултата за',
    filterAll: 'Сви',
    filterKatizma: 'Катизма',
    footerLine1: 'Превод: Епископ Атанасије (Јевтић)',
    footerLine2: 'Са црквено-словенског и грчког (према Седамдесеторици).',
    footerLine3: 'Извор: молитвеник.in.rs',
    alleluia: 'Алилуја.',
    back: 'Назад',
    smallerFont: 'Мање слово',
    largerFont: 'Веће слово',
    psalm: 'Псалам',
    openingVerse: 'почетни стих',
    openQuote: '„',
    noFullText1: 'Пун текст овог псалма биће додат у наредној верзији апликације.',
    noFullText2: 'За сада је доступан почетни стих по службеном преводу Епископа Атанасија (Јевтића).',
    glory: 'Слава Теби, Боже наш, слава Теби.',
  },
  en: {
    eyebrow: 'Of the Holy Prophet and King',
    title: 'Psalter',
    subtitle: "David's",
    count: '150 Psalms',
    quote: '"The Psalter never ceases"',
    quoteAuthor: '— Saint Sava of Serbia',
    searchPlaceholder: 'Search psalms (e.g., "have mercy" or 50)',
    noResults: 'No results for',
    filterAll: 'All',
    filterKatizma: 'Kathisma',
    footerLine1: "Translation: Brenton's English Septuagint (1851)",
    footerLine2: 'From the Greek (Septuagint), matching the Orthodox numbering.',
    footerLine3: 'Public domain',
    alleluia: 'Alleluia.',
    back: 'Back',
    smallerFont: 'Smaller font',
    largerFont: 'Larger font',
    psalm: 'Psalm',
    openingVerse: 'opening verse',
    openQuote: '“',
    noFullText1: 'Full text of this psalm will be added in a future update.',
    noFullText2: "Currently showing the opening verse from Brenton's English Septuagint.",
    glory: 'Glory to Thee, O God, glory to Thee.',
  },
}

const LanguageContext = createContext(null)

export function LanguageProvider({ children }) {
  const [language, setLang] = useState(
    () => localStorage.getItem('psalter-lang') || 'sr'
  )

  function setLanguage(lang) {
    localStorage.setItem('psalter-lang', lang)
    setLang(lang)
  }

  const value = useMemo(() => ({
    language,
    setLanguage,
    t: T[language],
    POCETAK: language === 'en' ? POCETAK_EN : POCETAK,
    NAPOMENE: language === 'en' ? NAPOMENE_EN : NAPOMENE,
    PUNI_TEKST: language === 'en' ? PUNI_TEKST_EN : PUNI_TEKST,
  }), [language])

  return <LanguageContext.Provider value={value}>{children}</LanguageContext.Provider>
}

export function useLanguage() {
  return useContext(LanguageContext)
}
