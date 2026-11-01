#!/usr/bin/env bash
# Helpers for the hook tests. $PROJECT is a fresh temporary directory per test.

# run_hook <script> <file path> : runs a hook with a tool-call payload for <file path>;
# sets $status, $out and $err.
run_hook() {
  local payload
  payload="$(jq -n --arg p "$2" '{tool_name: "Edit", tool_input: {file_path: $p}}')"
  set +e
  out="$(cd "$PROJECT" && CLAUDE_PROJECT_DIR="$PROJECT" "$PLUGIN_ROOT/hooks/$1" <<<"$payload" 2>"$PROJECT/.stderr")"
  status=$?
  set -e
  err="$(cat "$PROJECT/.stderr")"
  rm -f "$PROJECT/.stderr"
}

# set_phase <red|green> : marks the project as using pg, in the given TDD phase.
set_phase() {
  mkdir -p "$PROJECT/.pg/state"
  echo "$1" > "$PROJECT/.pg/state/tdd-phase"
}

assert_eq() {
  [[ "$1" == "$2" ]] || { echo "  expected '$2', got '$1' ${3:-}"; return 1; }
}

assert_contains() {
  [[ "$1" == *"$2"* ]] || { echo "  expected output to contain '$2', got: $1"; return 1; }
}
