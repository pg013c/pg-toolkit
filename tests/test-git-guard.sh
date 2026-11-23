#!/usr/bin/env bash
# git-guard: in a pg project, force pushes, pushes to the main branch and merging pull requests are refused
# unless .pg/allow lists them.
# shellcheck disable=SC2154

test_allows_everything_without_pg_directory() {
  run_bash_hook git-guard.sh "git push --force origin main"
  assert_eq "$status" 0
}

test_allows_ordinary_commands() {
  use_pg
  run_bash_hook git-guard.sh "git status && npm test"
  assert_eq "$status" 0
}

test_blocks_force_push_variants() {
  use_pg
  local cmd
  for cmd in "git push --force" "git push -f origin feat/x" "git push --force-with-lease" \
    "git push origin +feat/x" "cd app && git push -u -f origin feat/x" "git -C sub push --force"; do
    run_bash_hook git-guard.sh "$cmd"
    assert_eq "$status" 2 "for: $cmd"
  done
  assert_contains "$err" "force"
}

test_blocks_push_to_main_branch() {
  use_pg
  local cmd
  for cmd in "git push origin main" "git push origin master" "git push origin HEAD:main" "git push -u origin main"; do
    run_bash_hook git-guard.sh "$cmd"
    assert_eq "$status" 2 "for: $cmd"
  done
}

test_blocks_bare_push_while_on_main() {
  use_pg
  git_repo_on main
  run_bash_hook git-guard.sh "git push"
  assert_eq "$status" 2
}

test_allows_push_of_feature_branch() {
  use_pg
  git_repo_on feat/x
  run_bash_hook git-guard.sh "git push"
  assert_eq "$status" 0
  run_bash_hook git-guard.sh "git push -u origin feat/x"
  assert_eq "$status" 0
}

test_does_not_mistake_branch_names_containing_main() {
  use_pg
  run_bash_hook git-guard.sh "git push origin feat/maintenance"
  assert_eq "$status" 0
}

test_blocks_merging_pull_requests() {
  use_pg
  run_bash_hook git-guard.sh "gh pr merge 12 --squash"
  assert_eq "$status" 2
  assert_contains "$err" "merge"
}

test_allow_file_lifts_each_rule() {
  use_pg
  git_repo_on main
  printf '# solo repository\npush-main\nmerge\n' > "$PROJECT/.pg/allow"
  run_bash_hook git-guard.sh "git push origin main"
  assert_eq "$status" 0
  run_bash_hook git-guard.sh "gh pr merge 3"
  assert_eq "$status" 0
  run_bash_hook git-guard.sh "git push --force"
  assert_eq "$status" 2
}

test_ignores_commands_that_only_mention_git_push() {
  use_pg
  run_bash_hook git-guard.sh "echo 'never git push --force here'"
  assert_eq "$status" 0
}
