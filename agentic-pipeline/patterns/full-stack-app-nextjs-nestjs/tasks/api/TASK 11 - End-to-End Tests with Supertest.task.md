### Task 11 – End-to-End Tests with Supertest

**Goal**
Validate the full HTTP request-to-Postgres stack using real application wiring.

**Context**

* Create end-to-end (E2E) tests for the CRUD endpoints and DB persistence.
* E2E tests catch wiring mistakes that unit tests miss.

**Acceptance Criteria**

1. Test harness spins up NestJS app via `Test.createTestingModule()`.
2. `docker-compose -f infra/db.yml` starts Postgres for tests; Jest global setup waits for readiness.
3. Each Customer endpoint tested: POST-GET-PUT-DELETE happy-path and main error cases.
4. Test database rolled back between cases (use `queryRunner.startTransaction()` or truncate tables).
5. E2E tests run under `npm run test:e2e` and in CI workflow.

**Steps**

1. Install `supertest`, `@types/supertest`.
2. Add `project_root/api/test/e2e/{{project.domain.Domain Object}}.e2e-spec.ts`.
3. Configure Jest projects (`unit`, `e2e`) with separate ts-config.

