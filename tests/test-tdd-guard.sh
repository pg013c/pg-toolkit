#!/usr/bin/env bash
# tdd-guard: while a project's TDD phase is "green", edits to test files are refused.

test_allows_everything_without_pg_directory() {
  run_hook tdd-guard.sh "$PROJECT/tests/test_app.py"
  assert_eq "$status" 0
}

test_allows_test_edits_in_red_phase() {
  set_phase red
  run_hook tdd-guard.sh "$PROJECT/tests/test_app.py"
  assert_eq "$status" 0
}

test_blocks_test_edits_in_green_phase() {
  set_phase green
  run_hook tdd-guard.sh "$PROJECT/tests/test_app.py"
  assert_eq "$status" 2
  assert_contains "$err" "tests/test_app.py"
}

test_allows_code_edits_in_green_phase() {
  set_phase green
  run_hook tdd-guard.sh "$PROJECT/src/app.py"
  assert_eq "$status" 0
}

test_blocks_default_test_patterns_in_green_phase() {
  set_phase green
  local path
  for path in \
    src/app.test.ts web/src/Button.spec.tsx pkg/server_test.go app/tests/test_api.py \
    __tests__/x.js packages/ui/test/x.ts e2e/login.spec.ts conftest.py \
    src/test/java/AppTest.java tests/Feature/LoginTest.php evals/datasets/cases.yaml; do
    run_hook tdd-guard.sh "$PROJECT/$path"
    assert_eq "$status" 2 "for $path"
  done
}

test_project_patterns_replace_defaults() {
  set_phase green
  printf '# our layout\n\nspecs/*\n' > "$PROJECT/.pg/test-paths"
  run_hook tdd-guard.sh "$PROJECT/specs/login.rb"
  assert_eq "$status" 2
  run_hook tdd-guard.sh "$PROJECT/tests/test_app.py"
  assert_eq "$status" 0
}

test_ignores_files_outside_project() {
  set_phase green
  run_hook tdd-guard.sh "/elsewhere/tests/test_app.py"
  assert_eq "$status" 0
}

test_phase_file_whitespace_is_ignored() {
  mkdir -p "$PROJECT/.pg/state"
  printf '  green \n' > "$PROJECT/.pg/state/tdd-phase"
  run_hook tdd-guard.sh "$PROJECT/tests/test_app.py"
  assert_eq "$status" 2
}
