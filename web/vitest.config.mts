import { defineConfig } from "vitest/config";
import { fileURLToPath } from "node:url";

// Unit + component tests. E2E lives in e2e/ and runs under Playwright.
export default defineConfig({
  // tsconfig.json sets `jsx: "preserve"` for Next's own compiler, which leaves
  // JSX untransformed for the test runner. Transform it here instead.
  oxc: {
    jsx: { runtime: "automatic" },
  },
  resolve: {
    // Mirrors the "@/*" path alias in tsconfig.json.
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: ["./vitest.setup.ts"],
    include: ["src/**/*.test.{ts,tsx}"],
    exclude: ["e2e/**", "node_modules/**"],
    coverage: {
      provider: "v8",
      include: ["src/**/*.{ts,tsx}"],
      exclude: ["src/**/*.test.{ts,tsx}", "src/app/**/layout.tsx"],
    },
  },
});
