export default function Ornament({ size = 24 }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      className="inline-block opacity-70"
    >
      <path
        d="M12 2 L13 10 L21 11 L13 12 L12 22 L11 12 L3 11 L11 10 Z"
        fill="currentColor"
      />
      <circle cx="12" cy="11" r="1.5" fill="#faf5e8" />
    </svg>
  );
}
