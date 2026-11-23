# F-03. Review

- Range: `main...feat/F-03-login-rate-limit` at `4e1c9a2`
- Reviewer: `pg:reviewer` agent, fresh context
- Unconfirmed findings dropped: 1 (a claimed race between `check` and `fail`; the handler is sequential per request and the cache is synchronous)

## Findings

Severity: **blocker** (must fix before merge), **major** (fix in this feature), **minor** (fix or move to backlog), **note** (no action).

| # | Severity | Where | Finding | Rule or AC | Decision |
|---|---|---|---|---|---|
| R1 | major | `src/auth/rate-limit.ts:18` | The counter key is the raw email, so emails sit in memory dumps and debug output of the cache. | PRIV-12 | fix |
| R2 | minor | `src/auth/login.ts:29` | Addresses behind the proxy all look like the proxy's address unless the forwarded header is trusted; one user could lock out everyone behind it. | SEC-21, A07:2025 | backlog (F-09) |
| R3 | note | `tests/auth/rate_limit.test.ts:12` | The window length is repeated in the test instead of read from the limiter's options. | TEST-08 | reject: the explicit number documents the rule the spec states |

Decision, filled in by the human: `fix`, `backlog (F-xx)` or `reject: <reason>`.

## Resolution

| # | Commits |
|---|---|
| R1 | `7b2d0e1` test(auth): specify that the counter key never contains the raw email (review R1) · `a91c4f3` fix(auth): hash the email in the counter key (review R1) |
