# Changelog

## Unreleased

## 0.9.0 (2026-11-24)

- `/pg:save-note` and `/pg:inbox-tidy`: save a self-contained, confidentiality-checked note into your notes repository, and sort its inbox by an approved plan that flags anything already pushed.
- `/pg:draft-reply`: a reply drafted from the thread in the right voice, sent only after you approve the exact text.
- `/pg:inbox-loop`: an inbox handled one item at a time with a reminder, a recommendation and a draft, outcomes recorded in a tracker; it never sends anything itself.
- `/pg:progress`: a short session note in `docs/progress/` so work can be picked up without the conversation.
- `/pg:cleanup`: stale local branches and worktrees listed with what would be lost, deleted only on approval, with restore commands.

## 0.8.0 (2026-11-23)

- `/pg:report`: a plain-language report for a reader who does not read code, with every claim tied to an entry in a separate evidence file.
- `/pg:deck`: an outline you approve slide by slide, then one self-contained HTML presentation with keyboard navigation, speaker notes and a print-to-PDF layout.
- `/pg:workshop`: a workshop or training plan in a folder of markdown files: outcomes, pre-survey, timed agenda, exercises, facilitator guide, feedback survey and follow-up.
- `/pg:mock-interview`: interview practice with a chosen persona, one question at a time, ending with a readiness percentage and better answers built only from your own facts; `--talk` rehearses a presentation.

## 0.7.2 (2026-11-23)

- `/pg:eval-run`, from a real run: picks the suite when a project has several eval scripts, accepts an SDK or CLI login as the credential, asks before the first paid run with the case count and cost, keeps stdout-only results, finds baselines wherever the project keeps them (also another model's), tells a failure from a regression and a model comparison, records the run in the project's existing place, and never reruns a paid suite without a yes.
- `pg:eval-analyst` gets the eval command and traces each failing check through the scorer and the code that sets the checked field before blaming the prompt or model.

## 0.7.1 (2026-11-23)

- `/pg:audit`: finding ids are `<PREFIX>-A<n>` (for example `AI-A1`) so they never clash with rule ids, with fixed prefixes per area; severity and risk are defined; evaluation suites and anything that costs money are never run; disproved and unchecked candidates are kept apart; each finding shows its size and any extra locations.
- `/pg:research`: maps terms the code does not use to the closest concept and says so, checks every reference the answer and risks rest on and marks the rest `(unverified)`, keeps chat output short, and says which branch it commits on. `/pg:plan` summarises `research.md` and links to it.
- `/pg:release-gate`: short finding titles, rule names when the project's rules have no ids, and no empty findings table in the summary.

## 0.7.0 (2026-11-23)

- `/pg:research`: a read-only investigation of a question or a feature's area, with file references for what exists, what to reuse and what is risky. For a feature it writes `research.md`, and `/pg:plan` starts from it instead of researching again.
- `/pg:eval-run` and the `pg:eval-analyst` agent: run the project's evaluation suite, compare every metric with its target and the last baseline, explain regressions by the stage where they start, and record the run in `review.md` or `docs/evals/`. `/pg:init` adds an `Eval:` line to the "pg workflow" section when the project has a suite.
- `/pg:audit`: audits the whole repository in one area (security, ai, privacy, architecture, dead-code, performance, accessibility) or all of them, with verified findings that carry an id, severity, location, rule, evidence, fix and size, ready for the backlog.
- `/pg:release-gate`: an unattended gate for CI that writes a FAIL, WARN or PASS verdict as `gate.json` and a markdown summary for a pull-request comment. `/pg:init` gitignores `.pg/gate/`, its default output folder.
- Versioning: a pull request now ends with its own release commit; the tag and GitHub release follow the merge.

After updating: in a project set up earlier, add `.pg/gate/` to `.gitignore` if you run `/pg:release-gate` there without `--out`.

## 0.6.1 (2026-11-23)

- Removed `routines/` (the daily digest prompts). They were never part of the plugin and are no longer maintained here.

After updating: if you created scheduled tasks from `routines/`, they keep working; copy the prompts from the 0.6.0 tag if you want them again.

## 0.6.0 (2026-11-17)

- `/pg:discuss`: tell it the task you have to do and it talks it through with you - how it understands it, two or three approaches with a recommendation, risks, edge cases and questions, reading the repository read-only when the task is about it - round by round, ending with a summary of what was agreed. No code, no files, no artifacts.
- `/pg:improve-prompt`: give it a prompt, or a file holding one, and it rewrites it so a model understands it without guessing - goal and context added, a clear structure, vague words made concrete, contradictions removed - and returns it in one copyable block with what changed and why, plus questions where it had to guess. Later rounds refine it. It never runs the prompt.

## 0.5.0 (2026-11-16)

- `/pg:prd`: give it an idea, and optionally notes, code or old documents, and it interviews you as a principal architect until the spec is complete - business goal and MVP, tech stack, data model, flows and architecture, external dependencies, edge cases and non-functional requirements - pointing out bottlenecks, proposing options with a recommendation and ending every reply with a readiness percentage. On your command it writes a PRD/BRD for a coding agent in one markdown code block, ready for `/pg:build`.

## 0.4.0 (2026-11-13)

- `/pg:brainstorm`: give it an idea and it generates as many related ideas as it can - features, variants, related products, directions to grow, markets, ways to earn and wild cards - from several subagents with different creative lenses, merged into numbered clusters in chat with a short list worth a closer look. Later rounds give more, expand one idea, deepen a cluster or combine ideas. Nothing is built or sent.

## 0.3.0 (2026-11-06)

- Routines (outside the plugin): `daily-ai-news` and `daily-news`, scheduled-task prompts for the Claude desktop app that post a morning digest to Slack through webhooks read from `~/.config/daily-news/webhooks.env`. Setup in [routines/README.md](routines/README.md).
- `/pg:new-command`: describe what a command should do; it proposes a name and its own paraphrase of the goal, waits for your approval, then writes the skill, updates the docs, runs the checks, commits on a branch and opens a pull request to `main`.
- `/pg:slack-triage`: reads the Slack messages an instruction points at (a person, a channel, a time range) and writes a report in chat with one section per issue: topic, the quoted fragment, the problem stated concretely, a first analysis and the action for you. Read-only.
- `/pg:audit-branch`: audits a branch against a base (default `origin/main`) in a temporary worktree, using the project's own standards and compliance files first and the toolkit's standards where they are missing, and writes a report in chat with a merge-readiness percentage, risk per area, verified findings and what to do before merging. Read-only.
- `/pg:ideate`: give it an idea for an app, a game or a tool and it writes a sectioned report in chat - how it understands the idea, what is strong and weak, gaps, two or three ways to build it, directions to grow and extra features with wild cards - then refines it round by round. Nothing is built or written.
- `/pg:build`: give it a PRD and it splits it into features, then runs each one through the whole workflow - spec, plan, tdd step by step, review, ship - with every stage in its own subagent on the Sonnet model. You approve the split, each spec, each plan and each review triage; each push and pull request waits for your yes.
- Versioning rules in the toolkit's `CLAUDE.md`: pull requests add changelog lines only, and a tagged release with GitHub release notes follows each merge that users would notice. `/pg:new-command` reminds you to release after the merge.
- `security.md` takes the OWASP Top 10:2025 and ASVS 5.0 as its baseline and maps every Top 10 category to its rules. New rules close the gaps: SEC-13 (fail closed), SEC-14 (abuse cases for a new trust boundary), SEC-40 (hardened configuration), SEC-41 (security events logged and alerted).
- `ai.md` maps the OWASP Top 10 for LLM Applications 2025 and the Top 10 for Agentic Applications 2026 to its rules. New rules: AI-04 (pinned model and tool sources), AI-12 (no secrets in system prompts), AI-24 (the user's permissions, scoped credentials), AI-25 (traceable index and memory content), AI-26 (sandboxed generated code), AI-27 (confirmations show the real action), AI-34 (agent tool calls logged, agent can be stopped); AI-31 also caps input size.
- `pg:reviewer` checks security and AI changes against those OWASP maps and cites the OWASP category next to the rule id.

After updating: a project's standards are its own copies, and `/pg:init` never overwrites them. Compare them with the new templates and take what applies.

## 0.2.0 (2026-11-01)

- Standards: `ai.md`, `privacy.md` (GDPR and AI Act), `performance.md` and `accessibility.md` (WCAG 2.2 AA), plus a `docs/data-inventory.md` template.
- `/pg:init` copies each new standard only when the project shows it needs it, lists what it skipped and why, and can be run again to add a missing one.
- `pg:reviewer` reads every file in `docs/standards/` and checks AI, privacy, performance and accessibility, citing their rule ids.

After updating: in a project set up with 0.1.0, run `/pg:init` again to add the standards that apply.

## 0.1.0 (2026-11-01)

First release of the `pg` plugin.

- Skills: `init`, `spec`, `plan`, `tdd`, `review`, `ship`, `quick`, `adr`.
- Agent: `reviewer`, read-only, fresh context.
- Hooks: `tdd-guard` and `format-on-edit`, active only where `.pg/` exists.
- Templates: workflow, backlog, ADR, feature spec/plan/review, baseline standards (general, testing, security).
