import { useState } from 'react';
import PsalmList from './components/PsalmList.jsx';
import PsalmReader from './components/PsalmReader.jsx';

export default function App() {
  const [selected, setSelected] = useState(null);
  const [fontSize, setFontSize] = useState(18);

  return (
    <div className="font-serif antialiased">
      {selected === null ? (
        <PsalmList onSelect={setSelected} />
      ) : (
        <PsalmReader
          broj={selected}
          onBack={() => setSelected(null)}
          onNavigate={(n) => setSelected(n)}
          fontSize={fontSize}
          setFontSize={setFontSize}
        />
      )}
    </div>
  );
}
