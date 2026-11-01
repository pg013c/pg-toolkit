#!/usr/bin/env bash
# PostToolUse hook: format the edited file with the formatter of the nearest project that owns it.
# Only in projects with .pg/. A missing or failing formatter is never an error.
set -uo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
[[ -d "$root/.pg" ]] || exit 0
command -v jq >/dev/null || exit 0

path="$(jq -r '.tool_input.file_path // empty')"
[[ -n "$path" && -f "$path" && "$path" == "$root"/* ]] || exit 0

# nearest <marker file> : the closest directory from the file up to the root containing it.
nearest() {
  local dir
  dir="$(dirname "$path")"
  while [[ "$dir" == "$root" || "$dir" == "$root"/* ]]; do
    [[ -e "$dir/$1" ]] && { echo "$dir"; return 0; }
    dir="$(dirname "$dir")"
  done
  return 1
}

case "$path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.html|*.vue|*.svelte|*.md|*.yml|*.yaml)
    if dir="$(nearest package.json)"; then
      while [[ "$dir" == "$root" || "$dir" == "$root"/* ]]; do
        if [[ -x "$dir/node_modules/.bin/prettier" ]]; then
          "$dir/node_modules/.bin/prettier" --write --log-level silent "$path" >/dev/null 2>&1
          break
        fi
        dir="$(dirname "$dir")"
      done
    fi
    ;;
  *.py)
    if nearest pyproject.toml >/dev/null; then
      if command -v ruff >/dev/null; then
        ruff format --quiet "$path" >/dev/null 2>&1
        ruff check --fix --quiet "$path" >/dev/null 2>&1
      elif command -v uv >/dev/null; then
        dir="$(nearest pyproject.toml)"
        uv run --directory "$dir" --quiet ruff format --quiet "$path" >/dev/null 2>&1
        uv run --directory "$dir" --quiet ruff check --fix --quiet "$path" >/dev/null 2>&1
      fi
    fi
    ;;
  *.go)
    nearest go.mod >/dev/null && command -v gofmt >/dev/null && gofmt -w "$path" >/dev/null 2>&1
    ;;
  *.rs)
    nearest Cargo.toml >/dev/null && command -v rustfmt >/dev/null && rustfmt --quiet "$path" >/dev/null 2>&1
    ;;
esac
exit 0
