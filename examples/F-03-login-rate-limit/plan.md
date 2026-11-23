# F-03. Plan

- Status: approved
- Spec: [spec.md](spec.md)

## Research

Summary of the research note `/pg:research F-03` wrote (not included in this example):

- Login is handled in `src/auth/login.ts`; it checks the password with `verifyPassword` and answers through `sendError` in `src/http/errors.ts`, which already supports extra headers.
- `src/cache/ttl-cache.ts` is an in-memory cache with expiry and a fake clock for tests; it fits the counters.
- Risk: the handler logs the email on failure today (`src/auth/login.ts:41`); this feature must not copy that, and it is noted for the backlog (PRIV-12).

## Design

- `src/auth/rate-limit.ts`: `createLoginLimiter({ cache, clock, limit: 5, windowMs: 15 * 60_000 })` with `check(account, address)`, `fail(account, address)` and `reset(account)`.
- `login.ts` calls `check` before `verifyPassword`, `fail` after a wrong password, `reset` after a right one.
- No new dependency, no ADR.

## Steps

### Step 1. Count failures per account and address

- Kind: code
- Tests first: `tests/auth/rate_limit.test.ts`: `fail` increments both counters; counters expire after the window (fake clock).
- Change: add `src/auth/rate-limit.ts`.
- Done when: the new tests pass and the check command is green.
- [x] red
- [x] green

### Step 2. Refuse with 429 after five failures

- Kind: code
- Tests first: refuses the sixth attempt without calling `verifyPassword` (spy); limits by address across accounts; `Retry-After` equals the seconds left in the window; logs one `auth.rate_limited` event without the email or the password.
- Change: `src/auth/login.ts` calls `check` and `fail`; `sendError` gets the header.
- Done when: the new tests pass and the check command is green.
- [x] red
- [x] green

### Step 3. Reset on success

- Kind: code
- Tests first: three failures then the right password: login succeeds and the account counter is zero; the address counter is untouched.
- Change: `src/auth/login.ts` calls `reset`.
- Done when: the new tests pass and the check command is green.
- [x] red
- [x] green

## Acceptance criteria mapping

| AC | Proved by step |
|---|---|
| AC-1 | 2 |
| AC-2 | 2 |
| AC-3 | 3 |
| AC-4 | 2 |
