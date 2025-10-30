# Context

You are Codex, an AI coding agent. Your job is to follow the instructions in the AGENTS.md and execute tasks defined in the project_root/tasks directory. You must
follow the instructions (ie tasks, rules, etc).  

## Technology Stack

* **Application Code**

  * TypeScript 5.8 Lambda handlers (ES Modules, Node 20 arm64, IMDSv2)
  * **AWS Lambda Powertools v2.22** primitives integrated throughout:

    * `@aws-lambda-powertools/logger` – structured, JSON-formatted logging
    * `@aws-lambda-powertools/metrics` – custom and CloudWatch embedded metrics (EMF)
    * `@aws-lambda-powertools/tracer` – X-Ray auto-instrumentation & cold-start capture
    * `@aws-lambda-powertools/parameters` – cached access to SSM Parameter Store / Secrets Manager
    * `@aws-lambda-powertools/parser` – event-source–aware body parsing
    * `@aws-lambda-powertools/validation` – schema validation helpers (paired with **Zod 3.25**)
  * Business-logic service layer and DynamoDB data access (`@aws-sdk/*`)
  * Id generation via `uuid`, additional custom utilities as needed

* **Infrastructure as Code**

  * **Terraform ≥ 1.8** (AWS provider ≈ 5.x)
  * **HTTP API Gateway** (HTTP APIs) front-end
  * **AWS Lambda** (Node 20, arm64) with Powertools layers or bundled deps
  * **Amazon DynamoDB** single-table (`PAY_PER_REQUEST`), GSI **`gsi1`**

* **Build, Test & Lint**

  * **esbuild** bundling (tree-shakes Powertools for minimal cold-start size)
  * **Jest 29** + **ts-jest** for unit tests (Powertools utilities mock-friendly)
  * **ESLint / Prettier** for code quality; scripts: `lint`, `test`, `build`, `deploy` (Terraform apply)

* **Observability & Validation**

  * End-to-end tracing via Powertools **Tracer** (wrapping X-Ray)
  * Automatic structured logs and CloudWatch EMF metrics
  * Event and payload validation using **Powertools Validation** (+ Zod) and **ajv**

* **Package Management**

  * Deterministic builds via pinned versions in `package.json`; standard **npm** workflows


## TASK

- Tasks are contained in markdown files in the project_root/tasks directory.
- The agent executes each task sequentially. ie TASK 01, TASK 02, TASK 03, etc.
- If task fails record the failure in the session memory.

| Order | Task File                                                     | Objective                                                                                                          |
|-------|---------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| **1** | **Task 01 – Generate Source Code for CRUD Serverless App.md** | Scaffold and implement all TypeScript Lambda handlers, service layer, and validation logic.                        |
| **2** | **Task 02 – Generate Unit Tests.md**                          | Produce Jest unit & integration tests (≥ 90 % coverage) and one `.http` file per CRUD action, then run `npm test`. |
| **3** | **Task 03 – Generate Terraform Infrastructure.md**            | Build Terraform under `iac/` for API Gateway, Lambda, DynamoDB, remote-state placeholders, tags, and outputs.      |

Each task file template:

```
# TASK – <concise title>

## Goal
<Exactly what the agent must deliver>

## Inputs
<Any schemas, examples, session_memory files, or existing code references>

## Tools
| Tool ID | Shell Invocation | Purpose |
|---------|------------------|---------|
| …       | …                | …       |

## Acceptance Criteria
<Explicit pass/fail gates such as lint clean, tests green (≥ 90 % coverage), tflint OK, etc.>

## Deliverables
<Directories/files the agent must create or modify>
```

---

### SESSION MEMORY

* **Location** : `project_root/session_memory/`
* **Required Files**

  * `00_initial_input.md` — raw user prompt that started the run
  * `NN_task_<##>_output.md` — summary of each task’s deliverables
  * `NN_task_<##>_decisions.md` — key design decisions and rationale
* 
* **Workflow**

  1. User submits task.  Save human prompt as input in 00_initial_input.md.
  2. After finishing a task, write the corresponding output and decisions files.
  3. At the start of every task, load all existing session memory files as input.
  4. Past memory files are immutable; corrections are appended as new bullets in the latest decisions file.


---
### Execution of TASKs

1. **User** triggers Task 01 with a strategic chain-of-thought prompt.
2. **ServerlessArchitectBot**

* Save user input `session_memory/00_initial_input.md`.
* Run Task 01 and store `01_task_01_output.md` and `01_task_01_decisions.md`.
* Run Task 02 and store `02_task_02_output.md` and `02_task_02_decisions.md`.
* Run Task 03 and store `03_task_03_output.md` and `03_task_03_decisions.md`.
* Update `change_log.md` with a new semantic version entry and output next steps.


---


## RULES


### Metadata Header 

— Every source, test, and Terraform file must begin with JSDoc tags.
- Placement: Top of file, above any import or code statements.
- Enforcement: `npm_lint` fails if a header is missing or malformed.
- Version: Increment only when the file contents change.
- Date: UTC timestamp of the most recent change.


- Template
    ```markdown
      /**
      * App: {{Application Name}}
      * Package: {{package}}
      * File: {{file name}}
      * Version: semantic versioning starting at 0.1.0
      * Author: {{author}}
      * Date: {{YYYY-MM-DDThh:mm:ssZ}}
      * Exports: {{ exported functions, types, and variables.}}
      * Description: Level-5 documentation of the class or function. Document each
      *              method or function in the file.
      */
    ````

## Versioning Rules

      * Use **semantic versioning** (`MAJOR.MINOR.PATCH`).
      * Track changes each “AI turn” in `project_root/changelog.md`.
      * Start at **0.1.0**; update only when code or configuration changes.
      * Record only the sections that changed.

    ```markdown
    # Version History
    
    ### 0.0.1 – 2025-06-08 06:58:24 UTC (main)
    
    #### Task
    <Task>
    
    #### Changes
    - Initial project structure and configuration.
    
    ### 0.0.2 – 2025-06-08 07:23:08 UTC (work)
    
    #### Task
    <Task>
    
    #### Changes
    - Add tsconfig for ui and api.
    - Create src directories with unit-test folders.
    - Add e2e test directory for Playwright.
    ```

## ADR (Architecture Decision Record)

### Purpose

The `/adr` folder captures **concise, high-signal Architecture Decision Records** whenever the
AI coding agent (or a human) makes a non-obvious technical or architectural choice.
Storing ADRs keeps the project’s architectural rationale transparent and allows reviewers to
understand **why** a particular path was taken without trawling through commit history or code
comments.

### Location

```
project_root/adr/
```

### When the Agent Must Create an ADR

| Scenario                                                     | Example                                                                                                                                                                                                                                                                | Required? |
|--------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| Summarize Chain of Thought reasoning for the task           | Documenting the decision flow: ① capture requirements for a low-latency, pay-per-request CRUD API → ② compare DynamoDB single-table vs. Aurora Serverless → ③ choose DynamoDB single-table with GSI on email for predictable access patterns and minimal ops overhead. | **Yes**   |
| Selecting one library or pattern over plausible alternatives | Choosing Prisma instead of TypeORM                                                                                                                                                                                                                                     | **Yes**   |
| Introducing a new directory or module layout                 | Splitting `customer` domain into bounded contexts                                                                                                                                                                                                                      | **Yes**   |
| Changing a cross-cutting concern                             | Switching error-handling strategy to functional `Result` types                                                                                                                                                                                                         | **Yes**   |
| Cosmetic or trivial change                                   | Renaming a variable                                                                                                                                                                                                                                                    | **Yes**   |

### Naming Convention

```
adr/YYYYMMDDnnn_<slugified-title>.md
```

* `YYYYMMDD` – calendar date in UTC
* `nnn` – zero-padded sequence number for that day
* `slugified-title` – short, lowercase, hyphen-separated summary

Example: `adr/20250611_001_use-prisma-for-orm.md`.

### Minimal ADR Template

```markdown
# {{ADR Title}}

**Status**: Proposed | Accepted | Deprecated

**Date**: {{YYYY-MM-DD}}

**Context**  
Briefly explain the problem or decision context.

**Decision**  
State the choice that was made.

**Consequences**  
List the trade-offs and implications (positive and negative).  
```

## Git Workflow Conventions
 

### Branch Naming

```
<type>/<short-description>-<ticket-id?>
```

| Type       | Purpose                                | Example                           |
| ---------- | -------------------------------------- | --------------------------------- |
| `feat`     | New feature                            | `feat/profile-photo-upload-T1234` |
| `fix`      | Bug fix                                | `fix/login-csrf-T5678`            |
| `chore`    | Tooling, build, or dependency updates  | `chore/update-eslint-T0021`       |
| `docs`     | Documentation only                     | `docs/api-error-codes-T0099`      |
| `refactor` | Internal change w/out behaviour change | `refactor/db-repository-T0456`    |
| `test`     | Adding or improving tests              | `test/profile-service-T0789`      |
| `perf`     | Performance improvement                | `perf/query-caching-T0987`        |

**Rules**

1. One branch per ticket or atomic change.
2. **Never** commit directly to `main` or `develop`.
3. Re-base on the target branch before opening a pull request.

---

### Commit Messages (Conventional Commits)

```
AI Coding Agent Change:
<type>(<optional-scope>): <short imperative summary>
<BLANK LINE>
Optional multi-line body (wrap at 72 chars).
<BLANK LINE>
Refs: <ticket-id(s)>
```

Example:

```
feature(profile-ui): add in-place address editing

Allows users to update their address directly on the Profile Overview
card without navigating away. Uses optimistic UI and server-side
validation.

Refs: T1234
```

---

### Pull-Request Summary Template

Copy this template into every PR description and fill in each placeholder.

```markdown
# Summary
<!-- One-sentence description of the change. -->

# Details
* **What was added/changed?**
* **Why was it needed?**
* **How was it implemented?** (key design points)

# Related Tickets
- T1234 Profile Overview – In-place editing
- T1300 Validation Rules

# Checklist
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Linter passes
- [ ] Documentation updated

# Breaking Changes
<!-- List backward-incompatible changes, or “None” -->

# Codex Task Link
```

