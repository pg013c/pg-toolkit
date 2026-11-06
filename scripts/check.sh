#!/usr/bin/env bash
# Every check CI runs. Optional tools that are missing locally are skipped with a note; CI has them.
set -uo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root" || exit 1
failed=0

step() { printf '\n== %s\n' "$1"; }
fail() { echo "FAIL: $1"; failed=1; }

step "JSON files"
while IFS= read -r file; do
  jq empty "$file" >/dev/null 2>&1 || fail "invalid JSON: $file"
done < <(git ls-files --cached --others --exclude-standard '*.json')

step "Skill and agent frontmatter"
for file in plugins/pg/skills/*/SKILL.md plugins/pg/agents/*.md; do
  [[ -f "$file" ]] || continue
  head -1 "$file" | grep -qx -- '---' || { fail "$file: no frontmatter"; continue; }
  grep -qE '^name: [a-z0-9-]+$' "$file" || fail "$file: missing or invalid name"
  grep -qE '^description: .{20,}' "$file" || fail "$file: missing description"
done
for dir in plugins/pg/skills/*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  grep -qx "name: $name" "$dir/SKILL.md" 2>/dev/null || fail "$dir: name does not match the folder"
done

step "Private terms"
# The terms live outside the repository, so naming them here would defeat the point.
terms="${PG_PRIVATE_TERMS:-$HOME/.config/pg-toolkit/private-terms}"
if [[ -f "$terms" ]]; then
  patterns="$(mktemp)"
  grep -vE '^[[:space:]]*(#|$)' "$terms" >"$patterns"
  if [[ -s "$patterns" ]]; then
    hits="$(git ls-files --cached --others --exclude-standard -z \
      | xargs -0 grep -n -i -E -f "$patterns" -- 2>/dev/null)"
    if [[ -n "$hits" ]]; then
      echo "$hits"
      fail "private terms found"
    fi
  fi
  rm -f "$patterns"
else
  echo "skipped: no $terms"
fi

step "Hook tests"
tests/run.sh || fail "hook tests"

step "shellcheck"
if command -v shellcheck >/dev/null; then
  git ls-files --cached --others --exclude-standard '*.sh' | xargs shellcheck -x || fail "shellcheck"
else
  echo "skipped: shellcheck not installed"
fi

step "claude plugin validate"
if command -v claude >/dev/null; then
  claude plugin validate . >/dev/null || fail "marketplace does not validate"
  claude plugin validate plugins/pg >/dev/null || fail "plugin does not validate"
else
  echo "skipped: claude not installed"
fi

echo
if [[ $failed -ne 0 ]]; then
  echo "Checks failed."
  exit 1
fi
echo "All checks passed."
