/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      fontFamily: {
        display: ['"Cormorant Garamond"', '"Times New Roman"', 'serif'],
        serif: ['"EB Garamond"', '"Times New Roman"', 'serif'],
      },
    },
  },
  plugins: [],
};
