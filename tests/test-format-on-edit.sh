#!/usr/bin/env bash
# format-on-edit: after an edit, run the formatter of the nearest project that owns the file.

# fake_tool <dir> <name> : a stand-in formatter that records its arguments in $PROJECT/.calls.
fake_tool() {
  mkdir -p "$1"
  printf '#!/usr/bin/env bash\necho "%s $*" >> "%s/.calls"\n' "$2" "$PROJECT" > "$1/$2"
  chmod +x "$1/$2"
}

calls() { cat "$PROJECT/.calls" 2>/dev/null || true; }

test_does_nothing_without_pg_directory() {
  echo '{}' > "$PROJECT/package.json"
  fake_tool "$PROJECT/node_modules/.bin" prettier
  echo 'x' > "$PROJECT/a.ts"
  run_hook format-on-edit.sh "$PROJECT/a.ts"
  assert_eq "$status" 0
  assert_eq "$(calls)" ""
}

test_runs_local_prettier_for_web_files() {
  mkdir -p "$PROJECT/.pg"
  echo '{}' > "$PROJECT/package.json"
  fake_tool "$PROJECT/node_modules/.bin" prettier
  echo 'x' > "$PROJECT/a.ts"
  run_hook format-on-edit.sh "$PROJECT/a.ts"
  assert_eq "$status" 0
  assert_contains "$(calls)" "prettier --write --log-level silent $PROJECT/a.ts"
}

test_uses_nearest_package_in_monorepo() {
  mkdir -p "$PROJECT/.pg" "$PROJECT/apps/web/src"
  echo '{}' > "$PROJECT/package.json"
  echo '{}' > "$PROJECT/apps/web/package.json"
  fake_tool "$PROJECT/apps/web/node_modules/.bin" prettier
  echo 'x' > "$PROJECT/apps/web/src/a.tsx"
  run_hook format-on-edit.sh "$PROJECT/apps/web/src/a.tsx"
  assert_contains "$(calls)" "prettier --write"
}

test_runs_ruff_for_python_files() {
  mkdir -p "$PROJECT/.pg" "$PROJECT/bin"
  echo '[project]' > "$PROJECT/pyproject.toml"
  fake_tool "$PROJECT/bin" ruff
  echo 'x = 1' > "$PROJECT/a.py"
  PATH="$PROJECT/bin:$PATH" run_hook format-on-edit.sh "$PROJECT/a.py"
  assert_contains "$(calls)" "ruff format --quiet $PROJECT/a.py"
  assert_contains "$(calls)" "ruff check --fix --quiet $PROJECT/a.py"
}

test_runs_gofmt_for_go_files() {
  mkdir -p "$PROJECT/.pg" "$PROJECT/bin"
  echo 'module x' > "$PROJECT/go.mod"
  fake_tool "$PROJECT/bin" gofmt
  echo 'package x' > "$PROJECT/a.go"
  PATH="$PROJECT/bin:$PATH" run_hook format-on-edit.sh "$PROJECT/a.go"
  assert_contains "$(calls)" "gofmt -w $PROJECT/a.go"
}

test_skips_quietly_when_formatter_missing() {
  mkdir -p "$PROJECT/.pg"
  echo '{}' > "$PROJECT/package.json"
  echo 'x' > "$PROJECT/a.ts"
  run_hook format-on-edit.sh "$PROJECT/a.ts"
  assert_eq "$status" 0
  assert_eq "$err" ""
}

test_never_fails_when_formatter_fails() {
  mkdir -p "$PROJECT/.pg" "$PROJECT/node_modules/.bin"
  echo '{}' > "$PROJECT/package.json"
  printf '#!/usr/bin/env bash\nexit 3\n' > "$PROJECT/node_modules/.bin/prettier"
  chmod +x "$PROJECT/node_modules/.bin/prettier"
  echo 'x' > "$PROJECT/a.ts"
  run_hook format-on-edit.sh "$PROJECT/a.ts"
  assert_eq "$status" 0
}
