# TASK 02 – Generate Unit Tests

## Goal

Create **type-safe Jest 29 (ESM)** unit-test suites for **every exported function** in `src/**`, raising global branch/function/line coverage to **≥ 80 %** and ensuring `npm test` exits with status 0.
Tests must follow established patterns:

* Never mutate ESM exports; stub dependencies instead (e.g., DynamoDB client).
* Use `jest.fn<Promise<any>, [any]>()` for `ddb.send` mocks so `.mockResolvedValueOnce` is typed.
* Stub modules with `jest.unstable_mockModule()` **before** dynamic `import()` of the module under test.
* Fixtures must satisfy the domain types defined in `schema/domain.json`.
* **Quality gates** – Jest tests (≥ 90 % coverage) **plus** HTTP smoke-tests in `.http` files

All new files must include the standard metadata header and reside under `test/unit/`, mirroring source paths.

## Inputs

| Path / Reference                                  | Purpose                                        |
| ------------------------------------------------- | ---------------------------------------------- |
| `src/**`                                          | Production TypeScript modules to be exercised  |
| `test/unit/**`                                    | Existing Jest suites and patterns              |
| `schema/domain.json`                              | Domain types for valid fixtures                |
| `tsconfig.json`, `jest.config.js`, `package.json` | Compiler, test runner, and dependency versions |
| `session_memory/*.md`                             | Persisted context from prior tasks             |

## Tools

| Tool ID      | Shell Invocation | Purpose                             |
| ------------ | ---------------- | ----------------------------------- |
| npm\_install | `npm ci`         | Install dependencies                |
| npm\_lint    | `npm run lint`   | ESLint / Prettier conformance       |
| npm\_test    | `npm test`       | Compile & execute Jest suites       |
| npm\_build   | `npm run build`  | Build bundle (esbuild)              |
| file\_write  | *virtual*        | Create / overwrite repository files |

## Acceptance Criteria

1. `npm run build` completes without error.
2. `npm run lint` exits with code 0.
3. `npm test` passes with **≥ 90 %** global coverage for branches, functions, and lines.
4. Tests are located under `test/unit/**` and mirror source paths.
5. Metadata header present at the top of every new/updated test file.
6. No hard-coded AWS credentials or network calls; external effects are stubbed per the patterns above.
7. Each suite uses strict TypeScript, ESM syntax, and typed mocks.

## Deliverables

* New or updated test files under `test/unit/**`.
* Updated coverage report showing ≥ 90 %.
* `session_memory/02_task_02_output.md` — list of files created/modified and coverage stats.
* `session_memory/02_task_02_decisions.md` — key decisions, stubbing strategy notes, and any follow-up recommendations.
