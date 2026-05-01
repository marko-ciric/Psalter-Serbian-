import { useLanguage } from '../i18n/LanguageContext.jsx';

export default function PsalmListItem({ broj, opening, hasFull, onClick }) {
  const { t } = useLanguage();
  return (
    <button
      onClick={onClick}
      className="group w-full text-left flex items-baseline gap-4 py-4 px-4 sm:px-6 border-b border-amber-900/15 hover:bg-amber-50/60 active:bg-amber-100/60 transition-colors"
    >
      <span className="font-display text-2xl sm:text-3xl text-amber-900 font-semibold tracking-tight tabular-nums shrink-0 w-12 text-right group-hover:text-red-900 transition-colors">
        {broj}
      </span>
      <span className="flex-1 min-w-0">
        <span className="block font-serif text-stone-800 text-base sm:text-lg leading-snug">
          {opening}…
        </span>
        {!hasFull && (
          <span className="block text-xs text-stone-500 italic mt-1 font-serif">
            {t.openingVerse}
          </span>
        )}
      </span>
      <span className="text-amber-900/40 text-2xl shrink-0 group-hover:text-amber-900 group-hover:translate-x-1 transition-all">
        ›
      </span>
    </button>
  );
}
