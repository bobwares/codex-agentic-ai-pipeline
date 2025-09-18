### Task 06 – API Logging & Structured Request Tracing

| Field        | Value                                                   |
| ------------ | ------------------------------------------------------- |
| **Filename** | `Task 06 – API Logging & Structured Request Tracing.md` |
| **T-Ref**    | —                                                       |

**Goal**
Provide correlation-friendly, JSON-structured logs that include a per-request ID and latency.

**Context**

* Logs are copied into the repo after every Codex run; structure makes them searchable.
* Observability stack (Elastic / Grafana / CloudWatch Logs) expects JSON lines.

**Acceptance Criteria**

1. Integrate `@nestjs/pino` (or `nestjs-winston`) with pretty printing disabled in non-dev.
2. Middleware injects `X-Request-Id` header (uuid v4) if absent and attaches it to the logger context.
3. For every request, log:

    * `method`, `url`, `statusCode`, `responseTimeMs`, `requestId`.
4. Errors logged at level `error` with stack trace.
5. Configuration toggled via `LOG_LEVEL`, `PRETTY_LOGS`.
6. Unit tests assert that a log entry contains `requestId`.

**Steps**

1. `npm i @nestjs/pino pino-http pino-uuid –save`.
2. Create `LoggingModule` that registers `LoggerModule.forRootAsync()`.
3. Add `RequestIdMiddleware` and `LoggingInterceptor` for timing.
4. Update bootstrap order.
5. Extend CI to archive `./logs/api-YYYYMMDD.log`.

**DoD**

* `GET /health` produces one structured log line.
* `npm run lint` passes.
* Docs updated in `api/README.md`.
