#!/usr/bin/env bash
# PreToolUse hook: while the project's TDD phase is "green", test files are read-only.
# /pg:tdd sets the phase in .pg/state/tdd-phase; without that file nothing is blocked.
set -uo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
phase_file="$root/.pg/state/tdd-phase"
# shellcheck source=plugins/pg/hooks/lib/test-paths.sh
source "$(dirname "$0")/lib/test-paths.sh"

[[ -f "$phase_file" ]] || exit 0
[[ "$(tr -d '[:space:]' < "$phase_file")" == "green" ]] || exit 0

if ! command -v jq >/dev/null; then
  echo "pg tdd-guard: jq is not installed, test files are not protected." >&2
  exit 1
fi

path="$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')"
[[ -n "$path" && "$path" == "$root"/* ]] || exit 0
rel="${path#"$root"/}"

if is_test_path "$rel" "$root/.pg/test-paths"; then
  echo "pg tdd-guard: '$rel' is a test file and the /pg:tdd green phase is active." >&2
  echo "Make the code pass the tests as written. If a test is wrong, stop, explain why, and go back to the red phase with a separate test(...) commit." >&2
  exit 2
fi
exit 0
