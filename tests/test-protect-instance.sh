#!/usr/bin/env bash
# protect-instance: in a pg project, commands that would stop or change the instance the user works with
# (ports, data directories and commands listed in .pg/protected) are refused.
# shellcheck disable=SC2154

protect() {
  use_pg
  printf '# the instance I use every day\nport 4999\npath %s/live-data\ncommand pnpm app:*\n' "$PROJECT" > "$PROJECT/.pg/protected"
}

test_allows_everything_without_protected_file() {
  use_pg
  run_bash_hook protect-instance.sh "lsof -ti:4999 | xargs kill -9"
  assert_eq "$status" 0
}

test_blocks_killing_by_protected_port() {
  protect
  local cmd
  for cmd in "lsof -ti:4999 | xargs kill -9" "kill \$(lsof -t -i :4999)" "fuser -k 4999/tcp" "npx kill-port 4999"; do
    run_bash_hook protect-instance.sh "$cmd"
    assert_eq "$status" 2 "for: $cmd"
  done
  assert_contains "$err" "4999"
}

test_allows_killing_other_ports() {
  protect
  run_bash_hook protect-instance.sh "lsof -ti:5173 | xargs kill"
  assert_eq "$status" 0
}

test_allows_reading_the_protected_port() {
  protect
  run_bash_hook protect-instance.sh "curl -s http://127.0.0.1:4999/health"
  assert_eq "$status" 0
}

test_blocks_protected_commands() {
  protect
  run_bash_hook protect-instance.sh "pnpm app:restart"
  assert_eq "$status" 2
  run_bash_hook protect-instance.sh "cd web && pnpm app:stop"
  assert_eq "$status" 2
}

test_blocks_removing_or_moving_protected_paths() {
  protect
  local cmd
  for cmd in "rm -rf $PROJECT/live-data" "rm $PROJECT/live-data/app.db" "mv $PROJECT/live-data /tmp/x"; do
    run_bash_hook protect-instance.sh "$cmd"
    assert_eq "$status" 2 "for: $cmd"
  done
}

test_allows_reading_protected_paths_and_other_paths() {
  protect
  run_bash_hook protect-instance.sh "ls $PROJECT/live-data && rm -rf $PROJECT/tmp-data"
  assert_eq "$status" 0
}

test_expands_home_in_protected_paths() {
  use_pg
  printf 'path ~/.instance-data\n' > "$PROJECT/.pg/protected"
  run_bash_hook protect-instance.sh "rm -rf $HOME/.instance-data"
  assert_eq "$status" 2
}
