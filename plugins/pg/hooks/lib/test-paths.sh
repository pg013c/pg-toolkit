#!/usr/bin/env bash
# Which project paths count as tests or evaluation data. A project replaces the defaults with
# .pg/test-paths: one bash glob per line (`*` also matches `/`), `#` comments allowed.

PG_DEFAULT_TEST_PATHS=(
  'tests/*' '*/tests/*' 'test/*' '*/test/*' '__tests__/*' '*/__tests__/*'
  'e2e/*' '*/e2e/*' 'spec/*' '*/spec/*'
  'evals/datasets/*' '*/evals/datasets/*'
  '*.test.*' '*.spec.*' '*_test.go' '*_test.py' 'test_*.py' '*/test_*.py'
  'conftest.py' '*/conftest.py' '*Test.java' '*Test.kt' '*Test.php' '*Tests.cs'
)

# is_test_path <path relative to the project root> [patterns file]
is_test_path() {
  local path="$1" file="${2:-}" pattern
  local -a patterns=("${PG_DEFAULT_TEST_PATHS[@]}")

  if [[ -n "$file" && -f "$file" ]]; then
    patterns=()
    while IFS= read -r pattern || [[ -n "$pattern" ]]; do
      pattern="${pattern%%#*}"
      pattern="${pattern#"${pattern%%[![:space:]]*}"}"
      pattern="${pattern%"${pattern##*[![:space:]]}"}"
      [[ -n "$pattern" ]] && patterns+=("$pattern")
    done < "$file"
  fi

  for pattern in "${patterns[@]}"; do
    # shellcheck disable=SC2053
    [[ "$path" == $pattern ]] && return 0
  done
  return 1
}
