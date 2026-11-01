# Testing standards

## What to test

- **TEST-01** Every acceptance criterion has at least one test that would fail if the criterion were broken.
- **TEST-02** Tests assert behaviour visible from outside the unit (return values, state, calls across a boundary), not private details.
- **TEST-03** Every bug fix starts with a test that reproduces the bug.
- **TEST-04** Error paths and edge cases named in the spec are tested, not only the happy path.

## How

- **TEST-10** Unit tests do no real I/O: no network, disk, clock or randomness without a fake or a seed. They run in milliseconds.
- **TEST-11** Real adapters (database, HTTP, filesystem) have integration tests, kept separate and runnable on their own.
- **TEST-12** One reason to fail per test. The name states the behaviour: `returns_404_when_user_missing`, not `test_user_2`.
- **TEST-13** Arrange, act, assert, in that order and visibly separated. Shared setup lives in fixtures or builders, not copy-pasted.
- **TEST-14** Fakes over mocks for interfaces we own; a fake of a port follows the same contract test as the real adapter.
- **TEST-15** No sleeps. Wait on a condition with a timeout.

## Process

- **TEST-20** Red before green: the failing test is committed first, and the commit that makes it pass does not change it.
- **TEST-21** The full check command passes before every commit, not only the new tests.
- **TEST-22** A flaky test is fixed or quarantined with a backlog item the same day; it is never retried until green.
