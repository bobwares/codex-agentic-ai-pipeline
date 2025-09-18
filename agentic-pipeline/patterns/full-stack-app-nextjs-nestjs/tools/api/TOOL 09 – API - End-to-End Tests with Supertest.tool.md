### Task 09 – End-to-End Tests with Supertest

| Field        | Value                                          |
| ------------ | ---------------------------------------------- |
| **Filename** | `Task 09 – End-to-End Tests with Supertest.md` |
| **T-Ref**    | —                                              |

**Goal**
Validate the full HTTP request-to-Postgres stack using real application wiring.

**Context**

* Tickets 03-04 added CRUD endpoints and DB persistence.
* E2E tests catch wiring mistakes that unit tests miss.

**Acceptance Criteria**

1. Test harness spins up NestJS app via `Test.createTestingModule()`.
2. `docker-compose -f infra/db.yml` starts Postgres for tests; Jest global setup waits for readiness.
3. Each Customer endpoint tested: POST-GET-PUT-DELETE happy-path and main error cases.
4. Test database rolled back between cases (use `queryRunner.startTransaction()` or truncate tables).
5. E2E tests run under `npm run test:e2e` and in CI workflow.

**Steps**

1. Install `supertest`, `@types/supertest`.
2. Add `test/e2e/customer.e2e-spec.ts`.
3. Configure Jest projects (`unit`, `e2e`) with separate ts-config.
4. Create global setup/teardown script for Docker DB.
5. Document local workflow in `api/README.md`.

**DoD**

* `npm run test:e2e` green locally and in CI.
* Coverage report includes e2e numbers (optional).
* Logs archived per **AGENTS.md** instructions.
