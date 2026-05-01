import { useState, useMemo } from 'react';
import { Search, X } from 'lucide-react';
import { KATIZME } from '../data/katizme.js';
import { POCETAK } from '../data/pocetak.js';
import { PUNI_TEKST } from '../data/puniTekst.js';
import PsalmListItem from './PsalmListItem.jsx';
import Ornament from './Ornament.jsx';
import Divider from './Divider.jsx';

export default function PsalmList({ onSelect }) {
  const [search, setSearch] = useState('');
  const [activeKatizma, setActiveKatizma] = useState(null);

  const allPsalms = useMemo(() => {
    const list = [];
    for (let i = 1; i <= 150; i++) {
      list.push({
        broj: i,
        opening: POCETAK[i] || '',
        hasFull: !!PUNI_TEKST[i],
      });
    }
    return list;
  }, []);

  const filtered = useMemo(() => {
    let list = allPsalms;
    if (activeKatizma !== null) {
      const k = KATIZME.find((k) => k.broj === activeKatizma);
      if (k) list = list.filter((p) => k.psalmi.includes(p.broj));
    }
    if (search.trim()) {
      const q = search.toLowerCase().trim();
      list = list.filter(
        (p) =>
          p.opening.toLowerCase().includes(q) ||
          String(p.broj) === q ||
          String(p.broj).startsWith(q)
      );
    }
    return list;
  }, [search, activeKatizma, allPsalms]);

  return (
    <div className="min-h-screen parchment">
      {/* Header */}
      <header className="border-b border-amber-900/20 bg-gradient-to-b from-amber-50/40 to-stone-50">
        <div className="max-w-3xl mx-auto px-5 sm:px-8 pt-10 pb-8 text-center">
          <div className="flex items-center justify-center gap-3 mb-4 text-amber-900/70">
            <div className="h-px bg-amber-900/30 w-12" />
            <Ornament size={16} />
            <div className="h-px bg-amber-900/30 w-12" />
          </div>
          <p className="font-serif text-xs sm:text-sm tracking-[0.3em] uppercase text-amber-900/80 mb-3">
            Светог пророка и цара
          </p>
          <h1 className="font-display text-5xl sm:text-7xl font-bold text-amber-900 leading-none mb-3">
            Псалтир
          </h1>
          <p className="font-display italic text-stone-600 text-base sm:text-lg">Давидов</p>
          <div className="flex items-center justify-center gap-3 mt-5 text-amber-900/60">
            <div className="h-px bg-amber-900/30 w-8" />
            <span className="font-serif text-[11px] tracking-widest uppercase">150 псалама</span>
            <div className="h-px bg-amber-900/30 w-8" />
          </div>
          <p className="mt-6 font-serif italic text-stone-600 text-sm leading-relaxed max-w-md mx-auto">
            „Псалтир никада не престаје"
            <span className="block not-italic text-xs mt-1 text-amber-900/70">
              — Свети Сава Српски
            </span>
          </p>
        </div>
      </header>

      {/* Search & filters */}
      <div className="sticky top-0 z-10 bg-stone-50/95 backdrop-blur border-b border-amber-900/15">
        <div className="max-w-3xl mx-auto px-4 sm:px-6 py-3">
          <div className="relative">
            <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-amber-900/50" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Претражи псалме (нпр. „помилуј" или 50)"
              className="w-full pl-9 pr-9 py-2.5 bg-white border border-amber-900/25 rounded-sm font-serif text-stone-800 placeholder:text-stone-400 focus:outline-none focus:border-amber-900/60 focus:ring-1 focus:ring-amber-900/30"
            />
            {search && (
              <button
                onClick={() => setSearch('')}
                className="absolute right-2 top-1/2 -translate-y-1/2 p-1 text-stone-500 hover:text-stone-800"
              >
                <X size={14} />
              </button>
            )}
          </div>

          {/* Katizma chips */}
          <div className="flex gap-1.5 overflow-x-auto pb-1 mt-3 -mx-1 px-1 scrollbar-hide">
            <button
              onClick={() => setActiveKatizma(null)}
              className={`shrink-0 px-3 py-1 rounded-full text-xs font-serif border transition-colors ${
                activeKatizma === null
                  ? 'bg-amber-900 text-amber-50 border-amber-900'
                  : 'bg-white text-amber-900 border-amber-900/30 hover:border-amber-900/60'
              }`}
            >
              Сви
            </button>
            {KATIZME.map((k) => (
              <button
                key={k.broj}
                onClick={() => setActiveKatizma(k.broj === activeKatizma ? null : k.broj)}
                className={`shrink-0 px-3 py-1 rounded-full text-xs font-serif border transition-colors whitespace-nowrap ${
                  activeKatizma === k.broj
                    ? 'bg-amber-900 text-amber-50 border-amber-900'
                    : 'bg-white text-amber-900 border-amber-900/30 hover:border-amber-900/60'
                }`}
              >
                Катизма {k.broj}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* List */}
      <main className="max-w-3xl mx-auto px-1 sm:px-2 pb-20">
        {filtered.length === 0 ? (
          <div className="text-center py-20 font-serif italic text-stone-500">
            Нема резултата за „{search}".
          </div>
        ) : (
          <div className="bg-white sm:mx-2 sm:my-4 sm:border sm:border-amber-900/15 sm:rounded-sm sm:shadow-sm">
            {filtered.map((p) => (
              <PsalmListItem
                key={p.broj}
                broj={p.broj}
                opening={p.opening}
                hasFull={p.hasFull}
                onClick={() => onSelect(p.broj)}
              />
            ))}
          </div>
        )}

        {/* Footer */}
        <footer className="text-center mt-12 px-6">
          <Divider />
          <p className="font-serif text-xs text-stone-500 leading-relaxed">
            Превод: Епископ Атанасије (Јевтић)
            <br />
            Са црквено-словенског и грчког (према Седамдесеторици).
            <br />
            Извор: молитвеник.in.rs
          </p>
          <p className="font-display italic text-amber-900/70 text-sm mt-4">Алилуја.</p>
        </footer>
      </main>
    </div>
  );
}
