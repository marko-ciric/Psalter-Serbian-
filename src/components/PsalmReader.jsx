import { useEffect } from 'react';
import { ChevronLeft, Type, Plus, Minus } from 'lucide-react';
import { useLanguage } from '../i18n/LanguageContext.jsx';
import Divider from './Divider.jsx';

export default function PsalmReader({ broj, onBack, onNavigate, fontSize, setFontSize }) {
  const { t, POCETAK, NAPOMENE, PUNI_TEKST } = useLanguage();
  const stihovi = PUNI_TEKST[broj];
  const napomena = NAPOMENE[broj];
  const hasFull = !!stihovi;

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [broj]);

  return (
    <div className="min-h-screen parchment">
      {/* Top bar */}
      <div className="sticky top-0 z-10 bg-stone-50/95 backdrop-blur border-b border-amber-900/15">
        <div className="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
          <button
            onClick={onBack}
            className="flex items-center gap-1 text-amber-900 hover:text-red-900 active:text-red-900 transition-colors -ml-2 px-2 py-1"
          >
            <ChevronLeft size={20} />
            <span className="font-serif">{t.back}</span>
          </button>
          <div className="flex items-center gap-1">
            <button
              onClick={() => setFontSize(Math.max(14, fontSize - 2))}
              className="p-2 text-amber-900 hover:text-red-900 transition-colors"
              aria-label={t.smallerFont}
            >
              <Minus size={16} />
            </button>
            <Type size={16} className="text-amber-900/60" />
            <button
              onClick={() => setFontSize(Math.min(28, fontSize + 2))}
              className="p-2 text-amber-900 hover:text-red-900 transition-colors"
              aria-label={t.largerFont}
            >
              <Plus size={16} />
            </button>
          </div>
        </div>
      </div>

      {/* Content */}
      <article className="max-w-2xl mx-auto px-5 sm:px-8 py-10 sm:py-16">
        <div className="text-center mb-2">
          <span className="text-xs font-serif tracking-[0.3em] text-amber-900/70 uppercase">
            {t.psalm}
          </span>
        </div>
        <h1 className="font-display text-7xl sm:text-8xl text-center text-amber-900 font-bold leading-none mb-2 tabular-nums">
          {broj}
        </h1>
        <Divider />

        {napomena && (
          <p className="font-serif italic text-center text-stone-600 text-sm sm:text-base mb-8 px-4">
            {napomena}
          </p>
        )}

        {hasFull ? (
          <div
            className="font-serif text-stone-800 space-y-4"
            style={{ fontSize: `${fontSize}px`, lineHeight: 1.75 }}
          >
            {stihovi.map((stih, i) => (
              <p key={i} className="flex gap-3">
                <span className="text-amber-900/70 font-display font-semibold text-sm tabular-nums shrink-0 mt-1 select-none w-6">
                  {i + 1}
                </span>
                <span className="flex-1">
                  {i === 0 ? (
                    <>
                      <span className="font-display text-5xl sm:text-6xl float-left mr-2 mt-1 leading-[0.8] text-red-900 font-bold">
                        {stih.charAt(0)}
                      </span>
                      {stih.slice(1)}
                    </>
                  ) : (
                    stih
                  )}
                </span>
              </p>
            ))}
          </div>
        ) : (
          <div
            className="font-serif text-stone-800"
            style={{ fontSize: `${fontSize}px`, lineHeight: 1.75 }}
          >
            <p className="text-center italic text-stone-700 mb-6">
              {t.openQuote}{POCETAK[broj]}…"
            </p>
            <Divider />
            <div className="bg-amber-50/70 border border-amber-900/20 rounded-sm p-5 sm:p-6 text-center">
              <p className="font-serif italic text-stone-700 text-sm sm:text-base leading-relaxed">
                {t.noFullText1}
                <br className="hidden sm:block" />
                {t.noFullText2}
              </p>
            </div>
          </div>
        )}

        <Divider />
        <p className="text-center font-display italic text-amber-900/80 text-lg">
          {t.glory}
        </p>

        {/* Navigation between psalms */}
        <div className="mt-12 flex items-center justify-between gap-3 text-sm">
          {broj > 1 ? (
            <button
              onClick={() => onNavigate(broj - 1)}
              className="flex-1 py-3 px-4 border border-amber-900/25 rounded-sm font-serif text-stone-700 hover:bg-amber-50 transition-colors text-left"
            >
              <div className="text-xs text-amber-900/70 mb-0.5">← {t.psalm} {broj - 1}</div>
              <div className="truncate">{POCETAK[broj - 1]}…</div>
            </button>
          ) : (
            <div className="flex-1" />
          )}
          {broj < 150 ? (
            <button
              onClick={() => onNavigate(broj + 1)}
              className="flex-1 py-3 px-4 border border-amber-900/25 rounded-sm font-serif text-stone-700 hover:bg-amber-50 transition-colors text-right"
            >
              <div className="text-xs text-amber-900/70 mb-0.5">{t.psalm} {broj + 1} →</div>
              <div className="truncate">{POCETAK[broj + 1]}…</div>
            </button>
          ) : (
            <div className="flex-1" />
          )}
        </div>
      </article>
    </div>
  );
}
