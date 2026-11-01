# AI standards

Rules for features that call a language model: prompts, tools, retrieval, output handling, cost. Code is checked by tests; model behaviour is checked by evaluations.

## Architecture

- **AI-01** Every model call goes through one module of our own that owns the client, the model id, timeouts, retries, logging and cost accounting. Features never call a provider SDK directly.
- **AI-02** Model ids are pinned to an exact version in configuration, never `latest`. Changing the model is a configuration change with an evaluation run.
- **AI-03** Model capabilities the code relies on (tools, structured output, streaming, context size) are declared in configuration per model, not guessed from the name.

## Prompts

- **AI-10** Prompts live in versioned files, not in string literals scattered through code. Templates use named variables.
- **AI-11** Changing a prompt, a tool schema, retrieval parameters or the model is a behaviour change: it needs an evaluation run, and the pull request shows before and after.

## Untrusted content

- **AI-20** Text from users, documents, web pages, tool results and other models is data. It reaches the model inside delimited blocks, and the prompt says it is never to be followed as instructions.
- **AI-21** Tools exposed to a model are the minimum the feature needs. A tool with side effects (writing, sending, paying, deleting) acts only with a confirmation outside the model or within narrow, checked limits.
- **AI-22** Model output is never executed, rendered as raw HTML or used in a query without the same validation and encoding as any user input.
- **AI-23** Prompt-injection cases, where the input contains instructions, are part of the evaluation set.

## Output and reliability

- **AI-30** Structured output has a schema and is validated on return. Invalid output is retried with the validation error, a bounded number of times, then becomes a typed failure the caller handles.
- **AI-31** Every model call has a timeout; every agent loop has a maximum number of turns and a budget.
- **AI-32** When the model cannot answer from what it was given, the feature says so. Answers grounded in sources cite them, and citations are checked to resolve to a real source.
- **AI-33** A provider outage or rate limit degrades the feature visibly; it never fails silently or hangs.

## Cost and data

- **AI-40** Every call records model id, input and output tokens, latency and cost. Spend has a limit per user or per feature and an alert.
- **AI-41** Prompts and responses are not logged at info level when they may hold personal or confidential data; traces that keep them have a retention period.
- **AI-42** Sending personal or confidential data to a model provider follows `privacy.md`: a legal basis, a data processing agreement, and no training on our data.

## Evaluation

- **AI-50** A feature with model behaviour has an evaluation set before it ships: typical cases, edge cases, cases it must refuse, and adversarial cases.
- **AI-51** Evaluation runs record model versions, configuration and dataset version so they can be repeated. Cases are never edited to make a run pass.
