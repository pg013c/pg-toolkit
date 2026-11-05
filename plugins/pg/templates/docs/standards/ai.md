# AI standards

Rules for features that call a language model: prompts, tools, retrieval, output handling, cost. Code is checked by tests; model behaviour is checked by evaluations. The risk baseline is the [OWASP Top 10 for LLM Applications 2025](https://genai.owasp.org/llm-top-10/), plus the [OWASP Top 10 for Agentic Applications 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/) when a model calls tools or acts on its own; the tables at the end map each risk to its rules.

## Architecture

- **AI-01** Every model call goes through one module of our own that owns the client, the model id, timeouts, retries, logging and cost accounting. Features never call a provider SDK directly.
- **AI-02** Model ids are pinned to an exact version in configuration, never `latest`. Changing the model is a configuration change with an evaluation run.
- **AI-03** Model capabilities the code relies on (tools, structured output, streaming, context size) are declared in configuration per model, not guessed from the name.
- **AI-04** Models, weights, adapters, datasets, MCP servers and agent tools come from a named source and are pinned by version or checksum. Formats that run code on load (pickle and similar) are never loaded from outside.

## Prompts

- **AI-10** Prompts live in versioned files, not in string literals scattered through code. Templates use named variables.
- **AI-11** Changing a prompt, a tool schema, retrieval parameters or the model is a behaviour change: it needs an evaluation run, and the pull request shows before and after.
- **AI-12** System prompts hold no secrets, credentials or access rules. Write them as if the user can read them: anything the feature enforces is enforced in code.

## Untrusted content

- **AI-20** Text from users, documents, web pages, tool results and other models is data. It reaches the model inside delimited blocks, and the prompt says it is never to be followed as instructions.
- **AI-21** Tools exposed to a model are the minimum the feature needs. A tool with side effects (writing, sending, paying, deleting) acts only with a confirmation outside the model or within narrow, checked limits.
- **AI-22** Model output is never executed, rendered as raw HTML or used in a query without the same validation and encoding as any user input.
- **AI-23** Prompt-injection cases, where the input contains instructions, are part of the evaluation set.
- **AI-24** Retrieval and tools run with the permissions of the user the model acts for, never with a service account that sees more. Credentials an agent holds are scoped to the task and short-lived.
- **AI-25** Content that enters a retrieval index or an agent's memory has a recorded source and owner, comes only from allowed sources, and can be traced and removed.
- **AI-26** Code a model writes or chooses runs only in a sandbox: no secrets, no network unless the feature needs it, limits on time, memory and disk.
- **AI-27** A confirmation asked of a human shows the exact action and arguments the code will execute, not the model's summary of them.

## Output and reliability

- **AI-30** Structured output has a schema and is validated on return. Invalid output is retried with the validation error, a bounded number of times, then becomes a typed failure the caller handles.
- **AI-31** Every model call has a timeout; every agent loop has a maximum number of turns and a budget. Input size is capped before the call.
- **AI-32** When the model cannot answer from what it was given, the feature says so. Answers grounded in sources cite them, and citations are checked to resolve to a real source.
- **AI-33** A provider outage or rate limit degrades the feature visibly; it never fails silently or hangs.
- **AI-34** Every tool call an agent makes is logged with its arguments, result and the user it acted for, and a running agent can be stopped from outside the model.

## Cost and data

- **AI-40** Every call records model id, input and output tokens, latency and cost. Spend has a limit per user or per feature and an alert.
- **AI-41** Prompts and responses are not logged at info level when they may hold personal or confidential data; traces that keep them have a retention period.
- **AI-42** Sending personal or confidential data to a model provider follows `privacy.md`: a legal basis, a data processing agreement, and no training on our data.

## Evaluation

- **AI-50** A feature with model behaviour has an evaluation set before it ships: typical cases, edge cases, cases it must refuse, and adversarial cases.
- **AI-51** Evaluation runs record model versions, configuration and dataset version so they can be repeated. Cases are never edited to make a run pass.

## OWASP Top 10 for LLM Applications 2025 map

| Risk | Rules |
|---|---|
| LLM01:2025 Prompt Injection | AI-20, AI-21, AI-23 |
| LLM02:2025 Sensitive Information Disclosure | AI-24, AI-41, AI-42 |
| LLM03:2025 Supply Chain | AI-02, AI-04 |
| LLM04:2025 Data and Model Poisoning | AI-04, AI-25, AI-51 |
| LLM05:2025 Improper Output Handling | AI-22, AI-30 |
| LLM06:2025 Excessive Agency | AI-21, AI-24, AI-27 |
| LLM07:2025 System Prompt Leakage | AI-12 |
| LLM08:2025 Vector and Embedding Weaknesses | AI-24, AI-25 |
| LLM09:2025 Misinformation | AI-32, AI-50 |
| LLM10:2025 Unbounded Consumption | AI-31, AI-40 |

## OWASP Top 10 for Agentic Applications 2026 map

| Risk | Rules |
|---|---|
| ASI01 Agent Goal Hijack | AI-20, AI-23 |
| ASI02 Tool Misuse and Exploitation | AI-21, AI-22, AI-27 |
| ASI03 Identity and Privilege Abuse | AI-24 |
| ASI04 Agentic Supply Chain Vulnerabilities | AI-04 |
| ASI05 Unexpected Code Execution (RCE) | AI-22, AI-26 |
| ASI06 Memory & Context Poisoning | AI-25 |
| ASI07 Insecure Inter-Agent Communication | AI-20, SEC-10, SEC-12 |
| ASI08 Cascading Failures | AI-31, AI-33 |
| ASI09 Human-Agent Trust Exploitation | AI-21, AI-27 |
| ASI10 Rogue Agents | AI-31, AI-34 |
