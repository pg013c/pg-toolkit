# F-03. Limit failed logins

- Status: approved
- Related ADRs: none

## Why

Anyone can try passwords against an account as fast as the API answers. Account owners need guessing to be slow enough to be pointless, without locking them out for good. We will know it works when the sixth wrong password within fifteen minutes is refused without being checked.

## Scope

- Count failed logins per account and per client address, in a fifteen-minute window.
- After five failures for the same account or address, refuse further attempts with `429 Too Many Requests` and a `Retry-After` header, without checking the password.
- A successful login resets the account's counter.
- Each refusal is logged as a security event, without the email or the password.

## Out of scope

- Captcha and device fingerprinting (backlog F-07).
- Telling the account owner by email (backlog F-08).
- Shared counters across several API instances; the API runs as one instance today (see Open questions).

## Acceptance criteria

- [x] AC-1: Given five failed logins for one account within fifteen minutes, when a sixth attempt arrives with any password, then the API answers 429 with `Retry-After` and does not check the password (proof: `tests/auth/rate_limit.test.ts::refuses the sixth attempt without checking the password`)
- [x] AC-2: Given five failed logins from one address for different accounts, when another attempt arrives from that address, then it is refused the same way (proof: `tests/auth/rate_limit.test.ts::limits by address across accounts`)
- [x] AC-3: Given three failed logins, when the correct password is sent, then the login succeeds and the account's counter is back at zero (proof: `tests/auth/rate_limit.test.ts::a successful login resets the counter`)
- [x] AC-4: Given a refused attempt, then one `auth.rate_limited` event is logged with the address and a hash of the account, and neither the email nor the password appears in any log line (proof: `tests/auth/rate_limit.test.ts::logs the refusal without personal data`)

## Open questions

- Several instances later will need a shared store for the counters. Decided: not now; an ADR when we scale out.
