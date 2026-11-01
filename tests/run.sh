#!/usr/bin/env bash
# Runs every tests/test-*.sh file. Each file defines functions named test_*; each runs in its own
# subshell with a fresh temporary project in $PROJECT, and fails by returning non-zero.
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
export PLUGIN_ROOT="$here/../plugins/pg"
passed=0
failed=0

for file in "$here"/test-*.sh; do
  [[ -f "$file" ]] || continue
  for name in $(bash -c "source '$file'; declare -F" | awk '{print $3}' | grep '^test_'); do
    # Not in an `if`: bash ignores `set -e` there, and a failed assertion must end the test.
    (
      PROJECT="$(mktemp -d)"
      export PROJECT
      trap 'rm -rf "$PROJECT"' EXIT
      # shellcheck source=tests/lib.sh
      source "$here/lib.sh"
      # shellcheck disable=SC1090
      source "$file"
      set -e
      "$name"
    )
    result=$?
    if [[ $result -eq 0 ]]; then
      passed=$((passed + 1))
    else
      echo "FAIL $(basename "$file") $name"
      failed=$((failed + 1))
    fi
  done
done

echo "$passed passed, $failed failed"
[[ $failed -eq 0 ]]
