### Task 05 – Global Validation Pipe & Error Handling

| Field        | Value                                                  |
| ------------ | ------------------------------------------------------ |
| **Filename** | `Task 05 – Global Validation Pipe & Error Handling.md` |
| **T-Ref**    | —                                                      |

**Goal**
Guarantee every request is validated and every error is returned in a consistent JSON envelope (`statusCode`, `message`, `error`, `path`, `timestamp`).

**Context**

* Root **AGENTS.md** mandates strict input validation and clear error contracts.
* NestJS ships `ValidationPipe` and supports custom `ExceptionFilter`.
* Down-stream agents (front-end, tests, monitoring) rely on predictable error shapes.

**Acceptance Criteria**

1. `ValidationPipe` registered globally in `bootstrap()` with:

    * `whitelist: true`
    * `forbidNonWhitelisted: true`
    * `transform: true`
2. Custom `HttpExceptionFilter` extends `ExceptionFilter` and formats all thrown or unhandled errors.
3. Unknown routes return a 404 using the same envelope.
4. Unit tests:

    * 400 for bad payload (extra field, missing required).
    * 422 for validation failures (if using class-validator message map).
    * 404 for unknown route.
5. Swagger shows sample error schemas via `ApiExtraModels`.

**Steps**

1. Install `class-validator` and `class-transformer` (already present via earlier tasks).
2. Add `filters/http-exception.filter.ts`; bind via `app.useGlobalFilters()`.
3. Update `main.ts` to register `ValidationPipe`.
4. Write Jest tests for controller happy-path and error-path.
5. Add ADR **20250611\_002\_error-handling.md** to explain envelope choice.

**Definition of Done**

* `npm test` green; coverage for filter ≥ 90 %.
* `curl /unknown` returns JSON envelope.
* ADR merged.
