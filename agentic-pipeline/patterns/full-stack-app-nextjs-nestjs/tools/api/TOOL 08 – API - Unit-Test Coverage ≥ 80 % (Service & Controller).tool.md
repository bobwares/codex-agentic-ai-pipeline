### Task 08 – Unit-Test Coverage ≥ 80 % (Service & Controller)

| Field        | Value                                                 |
| ------------ | ----------------------------------------------------- |
| **Filename** | `Task 08 – Raise Unit-Test Coverage to 80 percent.md` |
| **T-Ref**    | —                                                     |

**Goal**
Guarantee confident refactoring by enforcing a minimum test-coverage threshold.

**Context**

* Current baseline has unit tests for Customer CRUD but overall coverage is below target.
* CI must fail if coverage slips.

**Acceptance Criteria**

1. `jest.config.ts` updated with `coverageThreshold` (lines, branches, funcs, stmts ≥ 80 %).
2. Additional unit tests written for:

    * Validation pipe behaviour.
    * Error filter mapping.
    * Service edge cases (duplicate email, soft-delete list filtering).
3. Local run of `npm test -- --coverage` prints ≥ 80 % across all metrics.
4. GitHub Actions step caches coverage report as artefact.

**Steps**

1. Identify gaps via `coverage/lcov-report/index.html`.
2. Create new tests in `test/unit/` folders.
3. Push PR and verify CI status.

**DoD**

* Coverage gate enforced in main branch protection rules.
* README badge shows latest percentage.
