import Foundation

// UI copy for both languages. Mirrors the `T` object from the web app's
// LanguageContext.jsx — when adding a new string, fill in both `sr` and `en`.
struct AppStrings {
    let eyebrow: String
    let title: String
    let subtitle: String
    let count: String
    let quote: String
    let quoteAuthor: String
    let searchPlaceholder: String
    let noResults: String
    let filterAll: String
    let filterKatizma: String
    let footerLine1: String
    let footerLine2: String
    let footerLine3: String
    let alleluia: String
    let back: String
    let smallerFont: String
    let largerFont: String
    let psalm: String
    let openingVerse: String
    let openQuote: String
    let noFullText1: String
    let noFullText2: String
    let glory: String

    static let sr = AppStrings(
        eyebrow: "Светог пророка и цара",
        title: "Псалтир",
        subtitle: "Давидов",
        count: "150 псалама",
        quote: "„Псалтир никада не престаје\"",
        quoteAuthor: "— Свети Сава Српски",
        searchPlaceholder: "Претражи псалме (нпр. „помилуј\" или 50)",
        noResults: "Нема резултата за",
        filterAll: "Сви",
        filterKatizma: "Катизма",
        footerLine1: "Превод: Епископ Атанасије (Јевтић)",
        footerLine2: "Са црквено-словенског и грчког (према Седамдесеторици).",
        footerLine3: "Извор: молитвеник.in.rs",
        alleluia: "Алилуја.",
        back: "Назад",
        smallerFont: "Мање слово",
        largerFont: "Веће слово",
        psalm: "Псалам",
        openingVerse: "почетни стих",
        openQuote: "„",
        noFullText1: "Пун текст овог псалма биће додат у наредној верзији апликације.",
        noFullText2: "За сада је доступан почетни стих по службеном преводу Епископа Атанасија (Јевтића).",
        glory: "Слава Теби, Боже наш, слава Теби."
    )

    static let en = AppStrings(
        eyebrow: "Of the Holy Prophet and King",
        title: "Psalter",
        subtitle: "David's",
        count: "150 Psalms",
        quote: "\"The Psalter never ceases\"",
        quoteAuthor: "— Saint Sava of Serbia",
        searchPlaceholder: "Search psalms (e.g., \"have mercy\" or 50)",
        noResults: "No results for",
        filterAll: "All",
        filterKatizma: "Kathisma",
        footerLine1: "Translation: Brenton's English Septuagint (1851)",
        footerLine2: "From the Greek (Septuagint), matching the Orthodox numbering.",
        footerLine3: "Public domain",
        alleluia: "Alleluia.",
        back: "Back",
        smallerFont: "Smaller font",
        largerFont: "Larger font",
        psalm: "Psalm",
        openingVerse: "opening verse",
        openQuote: "\u{201C}",
        noFullText1: "Full text of this psalm will be added in a future update.",
        noFullText2: "Currently showing the opening verse from Brenton's English Septuagint.",
        glory: "Glory to Thee, O God, glory to Thee."
    )
}
