# Example: one feature through the pg workflow

An invented feature in an invented project, a small web API with email-and-password login, shown as the files the workflow leaves behind. Nothing here comes from a real project.

[`F-03-login-rate-limit/`](F-03-login-rate-limit/) holds what each stage wrote: [spec.md](F-03-login-rate-limit/spec.md), [plan.md](F-03-login-rate-limit/plan.md) and [review.md](F-03-login-rate-limit/review.md).

## The session

| Step | Command | What happened | Human |
|---|---|---|---|
| Spec | `/pg:spec limit failed logins` | Five questions (window, threshold, what the client sees, unlock, logging), then the spec with four acceptance criteria. | approved after changing the threshold from 3 to 5 |
| Research | `/pg:research F-03` | Found the login handler, the existing in-memory cache with TTL, and that error responses already go through one helper. | |
| Plan | `/pg:plan F-03` | Three steps, each naming its tests first; every criterion mapped to a step. | approved |
| Build | `/pg:tdd F-03` ×3 | Six commits: `test(auth)` then `feat(auth)` per step. In step 2 the agent tried to loosen an assertion during green; `tdd-guard` refused the edit and it fixed the code instead. | |
| Review | `/pg:review F-03` | The `pg:reviewer` agent, with no access to the conversation, returned four findings; one was dropped as unconfirmed. | decided each finding |
| Fix | `/pg:tdd F-03 R1` | One red/green pair for the major finding. | |
| Ship | `/pg:ship F-03` | Every criterion proven by a named test, docs updated, pull request opened after a yes. | merged |

## The history it leaves

```text
docs(F-03): add spec
docs(F-03): add research
docs(F-03): add plan
test(auth): specify counting failed logins per account and address
feat(auth): count failed logins per account and address
test(auth): specify the 429 response with Retry-After after five failures
feat(auth): refuse logins with 429 and Retry-After after five failures
test(auth): specify that a successful login resets the counter
feat(auth): reset the counter on a successful login
docs(F-03): add review
test(auth): specify that the counter key never contains the raw email (review R1)
fix(auth): hash the email in the counter key (review R1)
docs(F-03): prove acceptance criteria, update README
```

Every behaviour change is a failing test first and the code second, visible in the log; the code commits do not touch tests.
