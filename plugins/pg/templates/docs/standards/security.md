# Security standards

## Input and output

- **SEC-01** All input from outside the process is validated at the boundary against a schema: type, size, format.
- **SEC-02** Queries are parameterised; shell commands get argument lists, never concatenated strings.
- **SEC-03** Output to HTML, SQL, shells, logs or prompts is encoded for that context.
- **SEC-04** File paths from users are resolved and checked against an allowed root.

## Access

- **SEC-10** Every endpoint and job states who may call it, and checks it on the server, per object as well as per route.
- **SEC-11** Default deny: new routes, buckets and roles start closed.
- **SEC-12** Sessions and tokens expire, can be revoked, and are compared in constant time.

## Secrets and data

- **SEC-20** No secrets in code, commits, logs, error messages or client bundles. They come from the environment or a secret store.
- **SEC-21** Personal data is collected only when needed, kept only as long as needed, and never logged.
- **SEC-22** Passwords are hashed with a slow, salted algorithm (argon2id, bcrypt or scrypt).

## Dependencies and AI

- **SEC-30** Dependencies are pinned through a lockfile and come from the official registry.
- **SEC-31** Text from documents, web pages, tools or users that reaches a model is treated as data: delimited, never followed as instructions, and model output is validated before it is acted on.
