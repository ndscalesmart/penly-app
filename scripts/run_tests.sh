#!/usr/bin/env bash
# Penly — full test suite. The single entry point referenced by
# .architecture/docs/standard-practice/standard-practice.md and run by CI.
#
# Usage:
#   ./scripts/run_tests.sh            # typecheck + unit + e2e
#   ./scripts/run_tests.sh --unit     # skip e2e (fast inner loop)
#   ./scripts/run_tests.sh --e2e      # e2e only
set -euo pipefail

cd "$(dirname "$0")/../web"

RUN_UNIT=1
RUN_E2E=1
case "${1:-}" in
  --unit) RUN_E2E=0 ;;
  --e2e)  RUN_UNIT=0 ;;
  "")     ;;
  *) echo "unknown option: $1" >&2; exit 2 ;;
esac

step() { printf '\n\033[1m── %s\033[0m\n' "$1"; }

if [ "$RUN_UNIT" -eq 1 ]; then
  step "Typecheck"
  npx tsc --noEmit

  step "Unit & component tests (Vitest)"
  npx vitest run
fi

if [ "$RUN_E2E" -eq 1 ]; then
  step "End-to-end tests (Playwright)"
  # Builds and starts the app on port 3100; see playwright.config.ts.
  npx playwright test
fi

printf '\n\033[32m✓ All checks passed\033[0m\n'
