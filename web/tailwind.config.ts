import type { Config } from "tailwindcss";

// "The Living Folio" design system — tokens mirror
// docs/penly-overview/penly-comprehensive-base44.md
const config: Config = {
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: "hsl(var(--ink))",
        cream: "hsl(var(--cream))",
        warm: "hsl(var(--warm))",
        paper: "hsl(var(--paper))",
        gold: "hsl(var(--gold))",
        "gold-light": "hsl(var(--gold-light))",
        rust: "hsl(var(--rust))",
        sage: "hsl(var(--sage))",
        "text-muted": "hsl(var(--text-muted))",
        border: "hsl(var(--warm))",
      },
      fontFamily: {
        display: ["var(--font-playfair)", "serif"],
        sans: ["var(--font-dm-sans)", "system-ui", "sans-serif"],
        mono: ["var(--font-dm-mono)", "monospace"],
      },
      transitionTimingFunction: {
        folio: "cubic-bezier(0.22, 1, 0.36, 1)",
      },
      keyframes: {
        "fade-up": {
          "0%": { opacity: "0", transform: "translateY(24px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        float: {
          "0%,100%": { transform: "translateY(0)" },
          "50%": { transform: "translateY(-12px)" },
        },
      },
      animation: {
        "fade-up": "fade-up 0.6s cubic-bezier(0.22,1,0.36,1) both",
        float: "float 6s ease-in-out infinite",
      },
    },
  },
  plugins: [],
};

export default config;
