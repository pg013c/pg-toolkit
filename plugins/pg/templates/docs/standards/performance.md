# Performance standards

## Budgets

- **PERF-01** The project states its budgets in this file and checks them where it can: for example p95 API latency, page load (LCP), JavaScript bundle size, memory per process, job duration.
- **PERF-02** Optimisation starts with a measurement that shows the problem and ends with a measurement that shows the gain. No optimisation by guess.

## Data access

- **PERF-10** No N+1 queries: related data is loaded in one query or a batch. Loops that call the database or a remote service are a review finding.
- **PERF-11** Lists that can grow are paginated or streamed, on the server and in the API. Nothing loads an unbounded collection into memory.
- **PERF-12** Queries used on hot paths have the indexes they need; a new query on a large table comes with its plan or a reason it is cheap.

## Work and waiting

- **PERF-20** Slow work (email, exports, model calls, image processing) runs in background jobs, not inside a request.
- **PERF-21** Independent remote calls run concurrently, each with a timeout (`GEN-21`).
- **PERF-22** Caches have an owner, a key, a TTL and an invalidation rule. A cache is not added to hide a slow query that can be fixed.

## Frontend

- **PERF-30** Routes and heavy components are split and loaded on demand. A new dependency's size is checked before it is added.
- **PERF-31** Images are sized for their slot, in a modern format, and lazy-loaded below the fold.
- **PERF-32** Lists with hundreds of rows are virtualised; expensive renders are measured with the profiler before being memoised.
