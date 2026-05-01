import Ornament from './Ornament.jsx';

export default function Divider() {
  return (
    <div className="flex items-center justify-center gap-4 my-8 text-amber-900">
      <div className="h-px bg-amber-900/30 flex-1 max-w-[120px]" />
      <Ornament size={18} />
      <div className="h-px bg-amber-900/30 flex-1 max-w-[120px]" />
    </div>
  );
}
