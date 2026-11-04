# Security standards

The baseline is the [OWASP Top 10:2025](https://owasp.org/Top10/2025/) for awareness and [OWASP ASVS 5.0](https://asvs.owasp.org/) for verification: Level 1 for anything reachable from the internet, Level 2 when the project holds personal data, money or credentials. The rules below are how this project meets them; the table at the end maps each Top 10 category to its rules. A question these rules do not answer is settled against ASVS, not improvised. Risks of model calls are in `ai.md`.

## Input and output

- **SEC-01** All input from outside the process is validated at the boundary against a schema: type, size, format.
- **SEC-02** Queries are parameterised; shell commands get argument lists, never concatenated strings.
- **SEC-03** Output to HTML, SQL, shells, logs or prompts is encoded for that context.
- **SEC-04** File paths from users are resolved and checked against an allowed root.

## Access

- **SEC-10** Every endpoint and job states who may call it, and checks it on the server, per object as well as per route.
- **SEC-11** Default deny: new routes, buckets and roles start closed.
- **SEC-12** Sessions and tokens expire, can be revoked, and are compared in constant time.
- **SEC-13** Failures fail closed: a failed check, a timeout or an unexpected error denies the request or rolls the operation back, and the caller sees a generic error, never a stack trace or internal detail.
- **SEC-14** A change that adds a trust boundary (an endpoint, a role, an upload, an integration, a webhook) names its abuse cases in the spec, and each has a test.

## Secrets and data

- **SEC-20** No secrets in code, commits, logs, error messages or client bundles. They come from the environment or a secret store.
- **SEC-21** Personal data is collected only when needed, kept only as long as needed, and never logged.
- **SEC-22** Passwords are hashed with a slow, salted algorithm (argon2id, bcrypt or scrypt).

## Dependencies and AI

- **SEC-30** Dependencies are pinned through a lockfile and come from the official registry.
- **SEC-31** Text from documents, web pages, tools or users that reaches a model is treated as data: delimited, never followed as instructions, and model output is validated before it is acted on.

## Configuration and monitoring

- **SEC-40** Deployed configuration is hardened and kept in code: debug modes, default accounts, sample pages and directory listings off; TLS and security headers on; nothing differs between environments by hand.
- **SEC-41** Security events (sign-in, failed sign-in, denied access, privilege changes, bursts of invalid input) are logged with who, what and when, without secrets or personal data, and the ones that need a human raise an alert.

## OWASP Top 10:2025 map

| Category | Rules |
|---|---|
| A01:2025 Broken Access Control | SEC-04, SEC-10, SEC-11 |
| A02:2025 Security Misconfiguration | SEC-11, SEC-40 |
| A03:2025 Software Supply Chain Failures | SEC-30 |
| A04:2025 Cryptographic Failures | SEC-20, SEC-22, SEC-40 |
| A05:2025 Injection | SEC-01, SEC-02, SEC-03, SEC-31 |
| A06:2025 Insecure Design | SEC-11, SEC-14 |
| A07:2025 Authentication Failures | SEC-12, SEC-22 |
| A08:2025 Software or Data Integrity Failures | SEC-01, SEC-30 |
| A09:2025 Security Logging and Alerting Failures | SEC-20, SEC-41 |
| A10:2025 Mishandling of Exceptional Conditions | SEC-13 |
