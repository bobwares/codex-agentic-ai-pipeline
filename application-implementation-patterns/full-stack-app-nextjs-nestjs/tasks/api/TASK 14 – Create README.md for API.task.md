# TASK 14 – Create README.md for API.task.md

## Goal

Create a complete, accurate README for the NestJS API that enables developers to clone, configure, run, migrate, test, and document the service with minimal friction.

## Context
This README consolidates the workflow introduced in Task 12 (Docker Compose for DB and API) and Task 13 (Makefile for DB, Migrations, App, and Compose). It must reflect the canonical commands, environment variables, and endpoints, and avoid environment default fallbacks in examples.

## Preconditions

* Task 12 completed (infra/docker-compose.yml, infra/.env, api/.env.local.example).
* Task 13 completed (top-level Makefile with compose-* and migrate-* targets).
* API supports health endpoints and OpenAPI docs (from earlier tasks).

## Outputs

* project_root/api/README.md

Authoritative outline and content requirements

## Section: Overview

* Describe stack: NestJS 11, TypeScript, TypeORM 0.3.x, PostgreSQL 16.
* State purpose of the service (one paragraph).
* List key features: health/readiness, structured error envelope, OpenAPI at /docs and /api/openapi.json.

## Section: Prerequisites

* Node.js 20+
* Docker and Docker Compose
* Make (for local workflows)

## Section: Quickstart

Provide exact commands as a copy-paste sequence from project_root:

```
make compose-up
make db-wait
make migrate-run
make api-dev
```

## Verification:

* Browser or curl: [http://localhost:${API_PORT}/health](http://localhost:${API_PORT}/health) should return status ok.
* If using VS Code REST Client, run requests in api/rest-tests/health.http.

## Section: Configuration

* Reference api/.env.local.example; instruct developers to copy it to api/.env.local.
* Document variables with one-line descriptions, no default fallbacks:

    * DATABASE_HOST
    * DATABASE_PORT
    * DATABASE_USERNAME
    * DATABASE_PASSWORD
    * DATABASE_NAME
    * DATABASE_SCHEMA
    * DATABASE_SSL
* Note that inside Compose the DATABASE_HOST must be db.
* State policy: do not use ${VAR:-default} in docs, scripts, or config examples.

## Section: Running with Docker Compose

* Start: make compose-up
* Logs: make compose-logs
* Stop: make compose-down
* Mention data persistence via the db_data volume.
* Link this section back to infra/.env for API_PORT and DB_* variables.

## Section: Database and Migrations

* Generate: make migrate-generate NAME=<description>
* Apply: make migrate-run
* Revert: make migrate-revert
* Location of data source: api/src/database/data-source.ts
* Location of migrations: api/src/migrations

## Section: Development Scripts

* Build: make api-build
* Test (unit): make api-test
* Dev server: make api-dev

## Section: API Documentation

* Swagger UI: [http://localhost:${API_PORT}/docs](http://localhost:${API_PORT}/docs)
* OpenAPI JSON: [http://localhost:${API_PORT}/api/openapi.json](http://localhost:${API_PORT}/api/openapi.json)
* Brief note on how to regenerate docs if your build step creates them (if applicable).

## Section: Health and Readiness

* Endpoints:
    * GET /health
    * GET /ready
* Expected 200 responses and minimal JSON shape description.

## Section: Error Handling Contract

* Describe the standard envelope fields: statusCode, message, error, path, timestamp.
* Note that validation errors (400) and unprocessable entity (422) use the same envelope.

## Section: Troubleshooting

* Port conflicts on API_PORT or DB_PORT.
* DATABASE_HOST must be db when running under Compose; localhost for direct local Postgres.
* How to inspect container env: make db-logs, make db-psql.

## Section: Project Structure

* Show a concise tree with api/src modules (controllers, services, entities, database) and test directories.

## Section: Conventions and Governance

* No environment fallbacks in docs or configs.
* Commit generated migrations and keep them reviewed.
* Keep README in sync when Makefile or Compose changes.

## Steps

1. Create project_root/api/README.md and populate it with the sections and details above.
2. Include code blocks for the Quickstart, Compose, and migration commands exactly as shown.
3. Link to api/rest-tests/health.http for manual checks.
4. Verify all URLs match API_PORT and the actual app prefix settings.
5. Re-read for any presence of default fallbacks in examples and remove them.

## Acceptance Criteria

* Following the Quickstart section on a clean clone produces a running API responding at /health and /docs.
* All commands in the README execute as written without additional flags or assumptions.
* OpenAPI is reachable at /api/openapi.json and /docs.
* No environment default fallback syntax (e.g., ${VAR:-value}) appears anywhere in the README.
* The README references the canonical Make targets and Compose files from Tasks 12 and 13 and contains no contradictory instructions.
