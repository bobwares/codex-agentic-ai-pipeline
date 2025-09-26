# TASK 01 – Generate Source Code for CRUD Serverless App 

## Goal

Produce a production-ready **CRUD** serverless application with a **DynamoDB single-table** design that fully adopts **AWS Lambda Powertools v2.22** for observability and validation.

### Required Capabilities

| Area                     | Requirements                                                                                                                                                                      |
|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Runtime**              | Node 20 arm64 + TypeScript 5.8                                                                                                                                                    |
| **Handlers**             | `create`, `get`, `update`, `patch`, `delete`, `list/search`                                                                                                                       |
| **API**                  | API Gateway **HTTP API** routing                                                                                                                                                  |
| **Persistence**          | Single DynamoDB table (PK/SK) + GSI **`gsi1`**                                                                                                                                    |
| **Observability**        | • `@aws-lambda-powertools/logger` for JSON logs<br>• `@aws-lambda-powertools/metrics` for CloudWatch EMF metrics<br>• `@aws-lambda-powertools/tracer` wrapping AWS X-Ray segments |
| **Validation / Parsing** | • `@aws-lambda-powertools/validation` + **Zod** 3.25 for payload validation<br>• `@aws-lambda-powertools/parser` for event-source parsing                                         |
| **Parameters / Secrets** | `@aws-lambda-powertools/parameters` cached access (future use; initialise helper)                                                                                                 |

---

## Inputs

| Path / Reference             | Purpose                                                     |
| ---------------------------- | ----------------------------------------------------------- |
| **User input** (JSON Schema) | Domain model; to be saved verbatim as `schema/domain.json`. |
| `package.json`               | Locked dependency versions.                                 |
| `session_memory/*.md`        | Persisted context from prior tasks.                         |

---

## Tools

| Tool ID      | Shell Invocation | Purpose                                                     |
| ------------ | ---------------- | ----------------------------------------------------------- |
| npm\_install | `npm install`    | Install dependencies.                                       |
| npm\_lint    | `npm run lint`   | ESLint / Prettier check; fix violations then rerun.         |
| npm\_build   | `npm run build`  | Production bundle (esbuild); fix compile errors then rerun. |
| npm\_test    | `npm run test`   | **Do NOT run in this task (reserved for Task 02).**         |

---

## Acceptance Criteria

1. **Compilation** – `npm run build` succeeds.
2. **Lint** – `npm run lint` exits 0.
3. **Handlers** – One Lambda entry point per CRUD action in `src/handlers/`.
4. **Service Layer** – Business logic isolated in `src/services/`.
5. **Data Access** – Table name via `TABLE_NAME`; single-table pattern with GSI `gsi1`.
6. **Logging** – Implement **Powertools Logger** singleton:

    * Error-level always; Debug-level only when `NODE_ENV=dev`, correlated by `requestId`.
7. **Metrics** – Emit at least one `ColdStart` and one domain metric (e.g., `CRUDSuccess`) via **Powertools Metrics**.
8. **Tracing** – Use **Powertools Tracer** to:

    * Decorate all handlers (`@tracer.captureLambdaHandler`).
    * Wrap DynamoDB DocumentClient (`captureAWSv3Client`).
9. **Validation & Parsing** –

    * Parse incoming events with **Powertools Parser**.
    * Validate request/response shapes with **Powertools Validation** (Zod schemas generated from the provided JSON Schema).
10. **Type Safety** – No `any` or `@ts-ignore`.
11. **Metadata Headers** – Every source file starts with the mandated JSDoc header.
12. **Schema Persisted** – JSON Schema saved exactly to `schema/domain.json`.

---

## Deliverables

| Path / File                              | Description                                                                                                                  |
|------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `src/handlers/*.ts`                      | Lambda entry points for **create, get, update, patch, delete, list** actions, each wrapped with Logger, Metrics, and Tracer. |
| `src/services/crud_service.ts`           | Business and DynamoDB data-access logic.  Methods: create, get, update, patch, delete, list.                                 |
| `src/utils/logger.ts`                    | Powertools Logger singleton (env-aware).                                                                                     |
| `src/utils/metrics.ts`                   | Powertools Metrics singleton, including a ColdStart metric.                                                                  |
| `src/utils/tracer.ts`                    | Powertools Tracer singleton plus AWS SDK capture helper.                                                                     |
| `src/utils/validation.ts`                | Zod schema generation & Powertools Validation helpers.                                                                       |
| `src/utils/parser.ts`                    | Powertools Parser helper (HTTP API → typed input).                                                                           |
| `schema/domain.json`                     | Verbatim copy of the user-provided domain schema.                                                                            |
| `session_memory/01_task_01_output.md`    | Summary of artefacts generated.                                                                                              |
| `session_memory/01_task_01_decisions.md` | Design decisions, rationale, and any ADR references.                                                                         |

All criteria must be satisfied to mark **Task 01** as complete and unlock Task 02.
