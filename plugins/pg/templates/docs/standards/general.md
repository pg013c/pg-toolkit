# General standards

Baseline rules for any stack. A project adds its own stack file (for example `typescript.md`, `python.md`) next to this one; `/pg:init` drafts it. Each rule has an id so reviews can cite it.

## Design

- **GEN-01** Each module has one reason to change. When a file needs "and" to describe it, split it.
- **GEN-02** Dependencies point inwards: domain logic does not import frameworks, databases or HTTP clients. It talks to them through interfaces it owns.
- **GEN-03** No speculative generality: no option, layer or abstraction without a current caller.
- **GEN-04** Duplicate twice, extract on the third time, and only when the copies change for the same reason.

## Code

- **GEN-10** Names say what a thing is or does in the language of the domain. No abbreviations a newcomer has to guess.
- **GEN-11** Functions do one thing at one level of abstraction. Long parameter lists become a named object.
- **GEN-12** Comments say why, never what. Dead code and commented-out code are deleted, not kept.
- **GEN-13** Configuration comes from the environment or config files, never from literals in code.

## Errors

- **GEN-20** Errors are handled where something useful can be done, and propagated otherwise. Never swallowed silently.
- **GEN-21** Every call across a process boundary (network, disk, subprocess, model) has a timeout and a bounded retry policy.
- **GEN-22** Error messages say what failed and what to do about it, without leaking secrets or personal data.

## Operations

- **GEN-30** Logs are structured and carry an id that ties together one request or job. No secrets or personal data in logs.
- **GEN-31** A new dependency is justified in the commit or an ADR: licence, maintenance, size, and what it replaces.
