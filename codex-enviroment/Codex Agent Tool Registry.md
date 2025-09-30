# Codex Agent Tool Registry

| Tool Name         | Description                                                                          | Inputs               | Outputs                                           |
| ----------------- | ------------------------------------------------------------------------------------ | -------------------- | ------------------------------------------------- |
| **LoadContext**   | Load project context (domain, stack, metadata) from `ai/context/project_context.md`. | None                 | Parsed project context object.                    |
| **InspectSchema** | Parse and validate authoritative JSON Schema (domain definition).                    | Path to schema file. | Structured schema object.                         |
| **ReadTask**      | Load a task definition from the `tasks/` directory.                                  | Task file name.      | Task metadata (goal, steps, acceptance criteria). |

---

### Code & Artifact Generation

| Tool Name                          | Description                                              | Inputs                              | Outputs                            |
| ---------------------------------- | -------------------------------------------------------- | ----------------------------------- | ---------------------------------- |
| **GenerateMigrationFromSchema**    | Create ORM migration (e.g., TypeORM) from JSON Schema.   | Schema object.                      | Migration class file(s).           |
| **GenerateEntities**               | Generate ORM entity classes (TypeORM, Prisma, etc.).     | Schema object.                      | `*.entity.ts` files.               |
| **GenerateDTOs**                   | Generate NestJS DTO classes with validation decorators.  | Schema object.                      | `*.dto.ts` files.                  |
| **GenerateControllersAndServices** | Scaffold REST controllers and services (CRUD + OpenAPI). | Schema object, domain context.      | `*.controller.ts`, `*.service.ts`. |
| **GenerateTests**                  | Create Jest test suites from schema and services.        | Schema object, service definitions. | `*.spec.ts` test files.            |
| **GenerateDocs**                   | Produce/update Markdown docs (README, task docs).        | Project context, schema.            | Markdown file(s).                  |

---

### Build & Runtime

| Tool Name            | Description                                    | Inputs                | Outputs                                        |
| -------------------- | ---------------------------------------------- | --------------------- | ---------------------------------------------- |
| **RunBuild**         | Execute project build (`npm run build`).       | None                  | Build logs + build artifacts.                  |
| **RunLint**          | Execute linter (`npm run lint`).               | None                  | Lint results (errors/warnings).                |
| **RunTests**         | Run unit/integration tests (`npm test`).       | Optional test filter. | Structured test results (pass/fail, coverage). |
| **RunMigrations**    | Apply DB migrations (`typeorm migration:run`). | None                  | Migration logs, DB state updated.              |
| **RevertMigrations** | Roll back last migration.                      | None                  | Migration rollback logs.                       |

---

### Ops & Utilities

| Tool Name             | Description                                       | Inputs                         | Outputs                            |
| --------------------- | ------------------------------------------------- | ------------------------------ | ---------------------------------- |
| **DockerComposeUp**   | Start services defined in `docker-compose.yml`.   | Optional service names.        | Running container logs, endpoints. |
| **DockerComposeDown** | Stop services from `docker-compose.yml`.          | Optional service names.        | Teardown logs.                     |
| **MakefileTask**      | Execute `make` targets (migrations, run, docker). | Target name.                   | Logs of make command.              |
| **LogCollector**      | Aggregate logs from build/test/runtime.           | Log type (build/test/runtime). | Structured log artifact.           |

---

### Agent Support

| Tool Name              | Description                                                | Inputs                       | Outputs                              |
| ---------------------- | ---------------------------------------------------------- | ---------------------------- | ------------------------------------ |
| **PlanTaskExecution**  | Decompose user instruction into subtasks and select tools. | Task description.            | Execution plan (ordered tool calls). |
| **SummarizeArtifacts** | Summarize/diff generated artifacts for user review.        | File paths or artifact refs. | Human-readable summary.              |
| **ErrorAnalyzer**      | Inspect error logs and propose corrective steps.           | Log artifact.                | Recommended tool calls or fixes.     |

---

This registry provides a **single source of truth** for what the Codex agent can do inside the sandbox. Each turn maps directly to one or more of these tools.

