import "@testing-library/jest-dom/vitest";
import { cleanup } from "@testing-library/react";
import { afterEach } from "vitest";

// Testing Library does not auto-cleanup when `globals` is on in some setups —
// do it explicitly so DOM state never leaks between tests.
afterEach(() => {
  cleanup();
});
