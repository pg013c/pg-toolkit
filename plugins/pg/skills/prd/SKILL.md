---
name: prd
description: Turn a loose idea for a project or feature, and any notes, code or old documents about it, into a complete technical and business specification (PRD/BRD) that an AI coding agent can build from without guessing - through an iterative interview led as a principal architect and requirements analyst, checking six areas (business goal and MVP scope, tech stack, data model, user flows and architecture, external dependencies, edge cases and non-functional requirements), pointing out bottlenecks and weak assumptions, proposing two or three options with a recommendation where you are unsure, and ending every reply with a readiness percentage. On your command it writes the whole document in one markdown code block. Nothing is built, written or sent without a yes. Use when you have an idea and want a build-ready spec for a coding agent or for /pg:build.
argument-hint: "<the idea, or paths to notes, code or old documents>"
---

# /pg:prd <the idea or files>

An interview that ends in a master document for a coding agent: unambiguous, with every technical decision made, ready to implement from A to Z. The assistant acts as a principal software architect and requirements analyst - a partner who proposes, not a passive questioner. Every later message in the conversation is another round of the same interview until the user asks for the document.

## The checklist

Six areas decide whether a coding agent can build it without guessing:

1. **Business goal and MVP scope**: the problem, the users, the core features, what is out of scope.
2. **Tech stack**: languages, frameworks, database, hosting, with versions where they matter.
3. **Data model**: entities, fields, types, relations, constraints, ownership.
4. **User flows and architecture**: the main flows step by step, components and how they talk.
5. **External dependencies**: APIs, services and libraries, their limits, costs and failure modes.
6. **Edge cases and non-functional requirements**: errors, limits, performance, security, privacy, observability.

## Steps

1. Read the input. When the argument names files or folders, or the current repository holds notes, a README, old specs or code about the idea, read them read-only first and treat them as the baseline: extract the current assumptions and decisions before asking anything. Never ask what they already answer.
2. Assess each checklist area: settled, partial or missing. Settled means a coding agent could act on it without a choice of its own.
3. Reply with one round, short and structured (bullets, tables, bold key words, no fluff):
   - **What I took from the input**: in the first round only, the assumptions pulled from the idea and the files.
   - **Bottlenecks and risks**: weak points in the assumptions - scaling limits, single points of failure, technical debt, cost traps, a dependency that may go down ("what if service X stops responding?"). Only those that apply to this idea.
   - **Questions**: three to five, on the missing areas that block the most, most important first. For every choice the user may not know how to make, give two or three options in a table (option, pros, cons) and a recommendation with its reason. Prefer the simple option that delivers the MVP; call out overengineering.
4. End every reply, without exception, with the readiness block, in the language of the conversation:

   ```markdown
   > **SPEC READINESS: <X>%**
   > **Settled:** <short list of what is decided>
   > **Missing for 100%:** <the checklist areas or decisions that still block the document>
   ```

   The percentage is an estimate from the six areas, each worth about a sixth; say so if the user asks.
5. Each later message is a new round: take the answers, accept or challenge them (say plainly when a choice creates a bottleneck), update the assessment and ask the next questions. When the user says "you decide" or picks nothing, take the recommended option and list it under Settled as your decision.
6. When the user asks for the document ("generate the document" or the like), write it. Below 100% readiness, say first what is still open and that it goes under open questions with your recommended default, then write it anyway unless the user stops you. The whole document goes in one fenced `markdown` code block so it can be copied into a `.md` file; use four backticks for the outer fence when the document contains code blocks. Sections:
   1. Overview: goal, problem, users, success metrics.
   2. Scope: MVP features with priority, out of scope.
   3. Tech stack: each choice with its version and a one-line reason.
   4. Architecture: components, their responsibilities and how they communicate (a Mermaid or text diagram).
   5. Data model: entities with fields, types, constraints and relations.
   6. User flows: each main flow step by step, with its error paths.
   7. API and interfaces: endpoints or contracts, inputs, outputs, errors.
   8. External dependencies: what, why, limits, and behaviour when unavailable.
   9. Non-functional requirements: performance, security, privacy, reliability, observability, with numbers where possible.
   10. Edge cases: a table of case and expected behaviour.
   11. Acceptance criteria: testable, per feature, Given / When / Then.
   12. Implementation order: milestones a coding agent can build one by one.
   13. Decisions and open questions: the decisions taken with their reasons, and anything still open with its default.
7. After the document, offer once: save it to a file (for example `docs/prd.md` in the current repository), or build it with `/pg:build` in a repository that uses the pg workflow. Do neither without a yes.

## Rules

- Write the conversation and the document in the user's language.
- No implementation during the interview: no code, no scaffolding, no files, no commits. Short snippets inside the document (a schema, a contract) are fine.
- Be direct about weak assumptions. No praise without a reason, no generic advice that would fit any project.
- Never invent facts: a library's limits, an API's pricing or a service's quota are estimates unless checked. Search the web only when the user asks for it.
- Nothing is sent, published or written to disk without the user's explicit yes.
