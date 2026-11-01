---
name: ship
description: Finish a feature branch - prove every acceptance criterion with its test, check that review findings are resolved, update the docs the change affected, then push and open a pull request after the human's go-ahead. Use after /pg:review findings are resolved.
argument-hint: F-xx
---

# /pg:ship F-xx

## Steps

1. Run the check command. It must pass.
2. For each acceptance criterion in `spec.md`, find the test that proves it and run it. Tick the criterion and write the pointer next to it. An unproven criterion stops the ship.
3. Check `review.md`: every finding has a decision, and every `fix` lists its commits.
4. Update what the feature changed: `README.md` (setup, usage), architecture docs, the ADR index, the backlog row (`done`). Commit `docs(F-xx): update docs for release`.
5. Ask before pushing. Then push the branch and open a pull request (`gh pr create`): summary, links to spec, plan and review, decisions the human made, how to try it.
   Without a remote (for example a take-home sent as an archive), skip the push and write the same summary to `SUBMISSION.md` instead.
6. Report the link or the file. Do not merge; the human merges.
