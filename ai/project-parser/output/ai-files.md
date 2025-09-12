# AI Workspace Files

_Generated on: 2025-09-12T19:42:19Z_

## File: project_root/AGENTS.md

```markdown
# Codex Session Context

open and read file /workspace/codex-agentic-ai-pipline/agentic-pipeline/context/codex_session_context.md

# Turns

open and read file /workspace/codex-agentic-ai-pipeline/agentic-pipeline/context/Turns_Technical_Design.md

# Codex Project Context

open and read file ./ai/context/codex_project_context.md


# Patterns

open and read pattern specified in the codex_project_context in the directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns

# Tasks

tasks are in directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/tasks

# Tools

tools are in directory /workspace/codex-agentic-ai-pipeline/agentic-pipeline/tools



# Coding Standards

## Metadata Header

— Every source, test, and IAC file must begin with Metadata Header comment section.
- exclude pom.xml
- Placement: Top of file, above any import or code statements.
- Version: Increment only when the file contents change.
- Date: UTC timestamp of the most recent change.


### Metadata Header Template
    ```markdown
      /**
      * App: {{Application Name}}
      * Package: {{package}}
      * File: {{file name}}
      * Version: semantic versioning starting at 0.1.0
      * Turns: append {{turn number}} list when created or updated.
      * Author: {{author}}
      * Date: {{YYYY-MM-DDThh:mm:ssZ}}
      * Exports: {{ exported functions, types, and variables.}}
      * Description: documentate the function of the class or function. Document each
      *              method or function in the file.
      */
    ````

### Source Versioning Rules

      * Use **semantic versioning** (`MAJOR.MINOR.PATCH`).
      * Start at **0.1.0**; update only when code or configuration changes.
      * Update the version in the source file if it is updated during a turn.

# Logging

## Change Log

- Track changes each “AI turn” in: project_root/ai/agentic-pipeline/turns/current turn directory/changelog.md
- append changes to project change log located project_root/changelog.md

### Change Log Entry Template

    # Turn: {{turn number}}  – {{Date Time of execution}}
    
    ## prompt

    {{ input prompt}}

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
   

## ADR (Architecture Decision Record)

### Purpose

The adr.md` folder captures **concise, high-signal Architecture Decision Records** whenever the
AI coding agent (or a human) makes a non-obvious technical or architectural choice.
Storing ADRs keeps the project’s architectural rationale transparent and allows reviewers to
understand **why** a particular path was taken without trawling through commit history or code
comments.

### Location

    project_root/ai/agentic-pipeline/turns/current turn directory/adr.md


### When the Agent Must Create an ADR

| Scenario                                                     | Example                                                                                                                                                                                                                                                                | Required? |
|--------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| Summarize Chain of Thought reasoning for the task            | Documenting the decision flow: ① capture requirements for a low-latency, pay-per-request CRUD API → ② compare DynamoDB single-table vs. Aurora Serverless → ③ choose DynamoDB single-table with GSI on email for predictable access patterns and minimal ops overhead. | **Yes**   |
| Selecting one library or pattern over plausible alternatives | Choosing Prisma instead of TypeORM                                                                                                                                                                                                                                     | **Yes**   |
| Introducing a new directory or module layout                 | Splitting `customer` domain into bounded contexts                                                                                                                                                                                                                      | **Yes**   |
| Changing a cross-cutting concern                             | Switching error-handling strategy to functional `Result` types                                                                                                                                                                                                         | **Yes**   |
| Cosmetic or trivial change                                   | Renaming a variable                                                                                                                                                                                                                                                    | **Yes**   |


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



```

## File: project_root/agentic-pipeline/context/Agentic_Pipeline_Definition.md

```markdown
# ChatGPT Codex Agentic Pipeline

## Overview

This repository defines an **agentic pipeline** for the ChatGPT Codex environment.
The pipeline enables iterative, tool-driven software generation where each execution is called a **turn**.

Key features:

* Structured orchestration via `AGENTS.md`
* Tool and task separation for modularity
* Persistent turn history with logs, inputs, outputs, and artifacts
* Metadata headers and versioning standards across all generated files
* Automated changelogs and Architecture Decision Records (ADRs)

---

## Concepts

### Turns

* A **turn** represents one execution of a Codex task.
* Each turn has a unique **Turn ID** (integer, incremented by 1 for each new turn).
* Turns create artifacts including:

    * **Changelog** entries
    * **Architecture Decision Records (ADR)**
    * Input and output directories for reproducibility

### Tasks

* A **task** is a prompt or workflow unit that Codex executes.
* Tasks are defined in `/tasks/` using Markdown (`*.prompt.md`), YAML, or JSON schemas.
* Tasks are modular and reusable, allowing flexible orchestration.

### Tools

* **Tools** encapsulate reusable operations that tasks can call.
* Examples:

    * SQL DDL generator
    * Test data generator
    * E2E HTTP test generator
    * OpenAPI annotator

### Orchestration (`AGENTS.md`)

* The **Codex agent** is configured in `AGENTS.md`.
* Defines how tools are chained together and how Codex interprets user requests.
* Enforces metadata headers and versioning for all generated files.

---

## Repository Layout

```
project root/AGENTS.md
project root/ai/tasks/
  person-crud-tool.prompt.md
  task.schema.json
  task.person-crud.yaml
project root/ai/tools/
  sql-ddl.prompt.md
  test-data.prompt.md
  e2e-http.prompt.md
  openapi-annotate.prompt.md
project root/ai/turns/
  index.csv
  2025-09-05T183000Z_turn-004/
    inputs/
    outputs/
    logs/
    artifacts/
agentic/
  context.schema.json
  tool.schema.json
  pipeline.config.yaml

```

---

## Metadata Standards

All source code, config, and prompt files must include a **metadata header**:

```
# App: {application-name}
# Package: {package-name}
# File: {file-name}
# Version: {semantic-version}
# Author: {author}
# Date: {ISO-8601 timestamp}
# Exports: {main classes, functions, or artifacts}
# Description: {purpose of this file}
```

---

## Workflow

1. **Start a Turn**

    * Increment Turn ID in `/turns/index.csv`.
    * Create a new turn directory (`/turns/{timestamp}_turn-{id}`).

2. **Execute a Task**

    * Run the chosen task through Codex.
    * Codex selects tools as needed.

3. **Generate Outputs**

    * Store results in `outputs/`.
    * Capture logs in `logs/`.

4. **Record Artifacts**

    * Store generated code, schemas, or configs in `artifacts/`.
    * Write/update ADR and changelog.



---

## Example Pipeline Flow

1. User requests a new CRUD module.
2. Codex executes the **CRUD task** → uses:

    * `sql-ddl.prompt.md` (generate SQL DDL)
    * `test-data.prompt.md` (generate test cases)
    * `e2e-http.prompt.md` (generate HTTP tests)
3. Outputs and artifacts stored under the active turn.
4. Changelog updated with the new feature.
5. ADR written to document design decisions.

---

## Goals

* Ensure reproducibility of every Codex execution
* Enforce standards for metadata and versioning
* Provide traceability via changelogs and ADRs
* Build modular, extensible pipelines that grow with project complexity

```

## File: project_root/agentic-pipeline/context/Turns_Technical_Design.md

```markdown
# Turns: Technical Design

## Core definitions

* **Turn**: a single execution of a Codex task (plan, generate, refactor, test, etc).
* **Turn ID**: a monotonically increasing integer. Initial value `1`. Incremented by `1` at the start of each new turn.
* **Artifacts per turn**:

    1. a changelog,
    2. an Architecture Decision Record (ADR),
    3. a manifest that indexes everything created/changed,
    4. optional logs (stdout/stderr), diffs, and test reports.

## Repository layout

```
/ai/agentic-pipeline/turns/
  1/
    manifest.json
    changelog.md
    adr.md
    diff.patch
    logs/
      task.log
      llm_prompt.txt
      llm_response.txt
    reports/
      tests.xml
      coverage.json

/turns/index.csv   # append-only registry of all turns
/docs/adr/         # (optional) symlink or copy of adr.md per turn if centralized ADRs are desired
```

## Turn lifecycle

1. **Plan**

    * Resolve inputs (task, domain schema, constraints).
    * Allocate next Turn ID (increment integer).
    * Create `/turns/<TurnID>/manifest.json` with initial metadata.

2. **Execute**

    * Run tools (e.g., codegen, tests).
    * Capture logs, diffs, generated files.

3. **Record**

    * Write `changelog.md` (human-readable delta, semver implications).
    * Write `adr.md` (context, options, decision, consequences).
    * Finalize `manifest.json` (hashes, file list, metrics).

4. **Commit & tag**

    * Commit with conventional message and the Turn ID.
    * Tag `turn/<TurnID>`.
    * Optionally open a PR referencing the Turn ID.

## Git integration

* **Branch naming (optional)**: `turn/<TurnID>[-<task>]`
* **Commit message template**:

  ```
  turn: <TurnID> <task> <scope>

  - Summary of changes
  - Key decisions: ADR#<TurnID>
  - Affected modules: <paths>
  - Tests: <added/updated status>

  Co-authored-by: Codex Agent <agent@local>
  ```
* **Tag**: `turn/<TurnID>` on the merge commit to main.
* **CI**: require presence/validity of `manifest.json`, `adr.md`, `changelog.md` for any turn branch.

## File specifications

### manifest.json (authoritative index)

Minimal schema:

```json
{
  "turnId": 1,
  "timestampUtc": "2025-09-05T17:42:10Z",
  "actor": {
    "initiator": "bobwares",
    "agent": "codex@1.0.0"
  },
  "task": {
    "name": "generate-controllers-and-services",
    "inputs": [
      "schemas/custodian.domain.schema.json"
    ],
    "parameters": {
      "language": "java",
      "framework": "spring-boot",
      "openapi": true
    }
  },
  "git": {
    "headBefore": "a1b2c3d",
    "headAfter": "d4e5f6a",
    "branch": "turn/1-generate",
    "tag": "turn/1"
  },
  "artifacts": {
    "changelog": "changelog.md",
    "adr": "adr.md",
    "diff": "diff.patch",
    "logs": ["logs/task.log", "logs/llm_prompt.txt", "logs/llm_response.txt"],
    "reports": ["reports/tests.xml", "reports/coverage.json"]
  },
  "changes": {
    "added": ["src/main/java/..."],
    "modified": ["..."],
    "deleted": []
  },
  "metrics": {
    "filesChanged": 12,
    "linesAdded": 350,
    "linesDeleted": 40,
    "testsPassed": 42,
    "testsFailed": 0,
    "coverageDeltaPct": 1.8
  },
  "validation": {
    "adrPresent": true,
    "changelogPresent": true,
    "lintStatus": "passed",
    "testsStatus": "passed"
  }
}
```

### changelog.md (human-readable delta)

```
# Turn 1 — Changelog
Date (UTC): 2025-09-05 17:42:10
Task: generate-controllers-and-services
Scope: customer, policy

## Summary
Generate CRUD controllers/services with OpenAPI annotations. Add integration tests.

## Changes
- Added: src/main/java/com/acme/customer/CustomerController.java
- Added: src/main/java/com/acme/customer/CustomerService.java
- Modified: build.gradle (add springdoc-openapi)
- Added: src/test/java/.../CustomerControllerIT.java

## Migrations
- None.

## SemVer Impact
- Minor: new public endpoints added, no breaking changes.

## Risks & Mitigations
- Risk: endpoint auth gaps. Mitigation: add security config in next turn.

## Linked Artifacts
- ADR: ./adr.md
- Diff: ./diff.patch
- Manifest: ./manifest.json
```

### adr.md (Architecture Decision Record)

```
# ADR 1: Controllers/Services with Spring Boot + OpenAPI

Date: 2025-09-05

## Status
Accepted

## Context
We need REST CRUD endpoints generated from the Custodian domain schema, with discoverable API docs.

## Options Considered
1) Spring MVC + springdoc-openapi
2) JAX-RS + Swagger (Quarkus/Jersey)
3) NestJS (Typescript) adapter to existing Node code

## Decision
Choose Spring MVC + springdoc-openapi. Aligns with existing Java stack, reduces cognitive load, integrates with current test infra.

## Consequences
- Positive: Low-friction developer experience, auto OpenAPI docs, easy testing.
- Negative: Ties us to Spring ecosystem for these services.
- Follow-ups: Add security annotations and global exception handlers next turn.

## References
- Manifest: ./manifest.json
- Changelog: ./changelog.md
- PR: <link or ID>
```

## CLI interface (thin wrapper)

Example commands:

```
codex-turn init --task generate-controllers-and-services --inputs schemas/custodian.domain.schema.json
codex-turn run  --plan file://plans/generate-controllers.yaml
codex-turn record --from-git --collect-logs
codex-turn finalize --commit --tag --open-pr
```

Behavior:

* `init` increments Turn ID, scaffolds `/turns/<TurnID>/`.
* `run` executes the task with logging.
* `record` computes `diff.patch`, detects changed files, builds `manifest.json`.
* `finalize` checks required artifacts, commits with conventional message, tags.

## CI policy

* Job `validate-turn` runs on any branch starting with `turn/`.
* Steps:

    1. Validate `manifest.json` against JSON Schema.
    2. Ensure `adr.md` and `changelog.md` exist and are non-empty.
    3. Ensure `diff.patch` matches repo delta.
    4. Run lint/tests; annotate metrics back into `manifest.json`.
    5. Upload `/turns/<TurnID>/` as build artifact.

Fail the build if any required artifact is missing.

## Commit conventions

* Conventional header style:

    * `turn: <TurnID> <task> [scope]`
* Example:

  ```
  turn: 1 generate-controllers-and-services [customer, policy]
  ```
* Footer fields (machine-parsable):

  ```
  Turn-Id: 1
  Turn-Task: generate-controllers-and-services
  Turn-Metrics-FilesChanged: 12
  Turn-Metrics-TestsPassed: 42
  ```

## Indexing

Append one line per turn to `/turns/index.csv`:

```
turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
```

```

## File: project_root/agentic-pipeline/context/codex_session_context.md

```markdown
# Codex Session Context


```

## File: project_root/agentic-pipeline/patterns/spring-boot-mvc-jpa-postgresql.pattern.md

```markdown
# Application Implementation Pattern

Spring Boot MVC + JPA + PostgreSQL

# Tech Stack

**Language & Runtime**

* Java 21 (LTS)

**Framework**

* Spring Boot 3.5.5

    * Spring MVC REST (API endpoints)
    * Spring Data JPA (relational persistence)
    * Spring Boot Actuator (health/metrics endpoints)
    * Springdoc OpenAPI (auto-generated API docs and Swagger UI)
    * Spring Boot Validation (Jakarta validation support)

**Database**

* PostgreSQL (recommended: 16.x stable)
* Flyway (database migrations, version-controlled schema evolution)

**Build Tool**

* Maven (with Spring Boot Maven Plugin, Compiler Plugin)
* Lombok (compile-time annotations for boilerplate reduction)
* MapStruct (optional, for DTO–entity mapping if needed)

**Testing**

* JUnit 5 (unit testing)
* Testcontainers (PostgreSQL integration tests in Docker)

**Containerization & Deployment**

* Docker (local development and production container builds)
* Docker Compose (optional for local multi-service orchestration)

---

# Notes and Best Practices

### 1. Spring Boot 3.5.5 with Java 21

* Fully compatible; configure Maven Compiler Plugin with `--release 21`.
* Keep dependencies managed by the Spring Boot BOM unless a pinned version is explicitly required (e.g., mapstruct, springdoc).

### 2. PostgreSQL with Docker

* Run local instance:
  `docker run --name mydb -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres:16`
* For pipelines: use Testcontainers for isolated ephemeral PostgreSQL instances.

### 3. Database Migrations with Flyway

* Store migration scripts in `src/main/resources/db/migration`.
* Version each change (e.g., `V1__init.sql`, `V2__add_customer_table.sql`).
* Spring Boot auto-runs migrations on startup.

### 4. Integration Setup

* Dev config: `application.yml` → `jdbc:postgresql://localhost:5432/mydb`.
* Override with env variables or Spring Profiles for prod/test.
* Use secrets management (not plain-text) for DB credentials in production.

### 5. API Documentation with Springdoc OpenAPI

* Adds `/swagger-ui.html` and `/v3/api-docs`.
* Auto-generates from controller annotations.

### 6. Observability with Actuator

* Exposes health checks (`/actuator/health`), metrics, and readiness probes.
* Integrates with Kubernetes liveness/readiness endpoints.

### 7. Lombok

* Reduces boilerplate in entities, DTOs, and configs.
* Keep `lombok.config` to enforce consistent usage.
* Requires IDE support.

### 8. Docker Compose Option

* Example `docker-compose.yml`:

    * `postgres` service
    * `spring-boot-app` service linked to DB
* Good for local multi-service integration testing.


```

## File: project_root/agentic-pipeline/tasks/create_app.task.md

```markdown
# Task - Create App

execute tasks

1. initialize_app.task.md
2. create_sql_ddl_from_schema.task.md
3. create_persistence_layer.task.md
4. create_rest_service.task.md

```

## File: project_root/agentic-pipeline/tasks/create_persistence_layer.task.md

```markdown
# Task – Create Persistence Layer (JPA)

## Workflow
1. execute tool persistence-generate_persistence_code.tool.md

```

## File: project_root/agentic-pipeline/tasks/create_rest_service.task.md

```markdown
# Task

Create a complete REST service based on input parameters.


## Workflow

- execute tool rest-generate_rest_api.tool.md

```

## File: project_root/agentic-pipeline/tasks/generate_normalized_tables_from_json_schema.task.md

```markdown
# TASK Generate Normalized Tables from JSON Schema

## Workflow
1. execute tool db-json_schema_to_sql_ddl.tool.md
2. execute tool db-create_test_data_for_schema.tool.md





```

## File: project_root/agentic-pipeline/tasks/initialize_app.task.md

```markdown
execute tools

1. maven-replace_maven_pom_elements.tool.md
```

## File: project_root/agentic-pipeline/tools/db-create_test_data_for_schema.tool.md

```markdown
# tool – DB – Create Test Data for Schema

### Context

Create SQL statements to insert the initial set of data for the domain in to the SQL database.


- File location:** `db/scripts/<domain>_test_data.sql`
- Insert 20 sets domain objects** 
- Idempotent** – use `INSERT … ON CONFLICT DO NOTHING`.
- Metadata header** (App, Package, File, Version, Author, Date, Description).
- Realistic sample data** (names + emails).
- Timestamps in UTC** (script comment or explicit `timezone` clause).
- Smoke-test query** that counts rows.
- Follow project SQL style conventions.

---

### Acceptance Criteria

* Script file exists at `project_root/db/scripts/<domain>_test_data.sql`.
* Header present and accurate.
* Exactly 20 `INSERT` rows, each idempotent.
* Script runs cleanly multiple times without duplicate rows.
* Smoke-test query present and returns **≥ 10** rows after first run.

---

### Example Execution

**Input**

File: project_root/db/entity-specs/customer_profile-entities.json

```json
{
"$schema": "https://json-schema.org/draft/2020-12/schema",
"$id": "<repo-root>/entity-specs/customer_profile-entities.json",
"title": "customer_profile Domain Entities",
"type": "object",
"x-db": { "schema": "customer_profile" },
"definitions": {
"PostalAddress": {
"type": "object",
"properties": {
"address_id": { "type": "integer" },
"line1":      { "type": "string", "maxLength": 255 },
"line2":      { "type": "string", "maxLength": 255 },
"city":       { "type": "string", "maxLength": 100 },
"state":      { "type": "string", "maxLength": 50 },
"postal_code":{ "type": "string", "maxLength": 20 },
"country":    { "type": "string", "minLength": 2, "maxLength": 2 }
},
"required": [ "address_id", "line1", "city", "state", "country" ],
"x-db": {
"primaryKey": [ "address_id" ]
}
},

    "PrivacySettings": {
      "type": "object",
      "properties": {
        "privacy_settings_id":     { "type": "integer" },
        "marketing_emails_enabled":{ "type": "boolean" },
        "two_factor_enabled":      { "type": "boolean" }
      },
      "required": [
        "privacy_settings_id",
        "marketing_emails_enabled",
        "two_factor_enabled"
      ],
      "x-db": {
        "primaryKey": [ "privacy_settings_id" ]
      }
    },

    "Customer": {
      "type": "object",
      "properties": {
        "customer_id":         { "type": "string", "format": "uuid" },
        "first_name":          { "type": "string", "maxLength": 255 },
        "middle_name":         { "type": "string", "maxLength": 255 },
        "last_name":           { "type": "string", "maxLength": 255 },
        "address_id":          { "type": "integer" },
        "privacy_settings_id": { "type": "integer" }
      },
      "required": [ "customer_id", "first_name", "last_name" ],
      "x-db": {
        "primaryKey": [ "customer_id" ],
        "foreignKey": [
          { "column": "address_id",          "ref": "PostalAddress.address_id" },
          { "column": "privacy_settings_id", "ref": "PrivacySettings.privacy_settings_id" }
        ],
        "indexes": [
          [ "address_id" ],
          [ "privacy_settings_id" ]
        ]
      }
    },

    "CustomerEmail": {
      "type": "object",
      "properties": {
        "email_id":    { "type": "integer" },
        "customer_id": { "type": "string", "format": "uuid" },
        "email":       { "type": "string", "maxLength": 255 }
      },
      "required": [ "email_id", "customer_id", "email" ],
      "x-db": {
        "primaryKey": [ "email_id" ],
        "foreignKey": { "column": "customer_id", "ref": "Customer.customer_id" },
        "unique":     [ [ "customer_id", "email" ] ],
        "indexes":    [ [ "customer_id" ] ]
      }
    },

    "CustomerPhoneNumber": {
      "type": "object",
      "properties": {
        "phone_id":    { "type": "integer" },
        "customer_id": { "type": "string", "format": "uuid" },
        "type":        { "type": "string", "maxLength": 20 },
        "number":      { "type": "string", "maxLength": 15 }
      },
      "required": [ "phone_id", "customer_id", "type", "number" ],
      "x-db": {
        "primaryKey": [ "phone_id" ],
        "foreignKey": { "column": "customer_id", "ref": "Customer.customer_id" },
        "unique":     [ [ "customer_id", "number" ] ],
        "indexes":    [ [ "customer_id" ] ]
      }
    }
}
}
```
**Output**

File: project_root/db/test/01_customer_domain_test_data.sql

```sql
-- App: Client Profile Module
-- Package: db
-- File: 01_customer_domain_test_data.sql
-- Version: 0.0.4
-- Author: Bobwares
-- Date: 2025-06-12T01:30:00Z
-- Description: Inserts sample customer domain data for testing purposes.
--
BEGIN;

-- Insert postal addresses
INSERT INTO postal_address (address_id, line1, line2, city, state, postal_code, country)
VALUES
    (1, '100 Market St', NULL, 'Springfield', 'IL', '62701', 'US'),
    (2, '200 Oak Ave', 'Apt 2', 'Madison', 'WI', '53703', 'US'),
    (3, '300 Pine Rd', NULL, 'Austin', 'TX', '73301', 'US'),
    (4, '400 Maple Ln', NULL, 'Denver', 'CO', '80014', 'US'),
    (5, '500 Cedar Blvd', 'Suite 5', 'Phoenix', 'AZ', '85001', 'US'),
    (6, '600 Birch Way', NULL, 'Portland', 'OR', '97035', 'US'),
    (7, '700 Walnut St', NULL, 'Boston', 'MA', '02108', 'US'),
    (8, '800 Chestnut Dr', NULL, 'Seattle', 'WA', '98101', 'US'),
    (9, '900 Elm Cir', NULL, 'Atlanta', 'GA', '30303', 'US'),
    (10, '1000 Ash Pl', NULL, 'Miami', 'FL', '33101', 'US')
ON CONFLICT DO NOTHING;

-- Insert privacy settings
INSERT INTO privacy_settings (privacy_settings_id, marketing_emails_enabled, two_factor_enabled)
VALUES
    (1, TRUE, FALSE),
    (2, FALSE, TRUE),
    (3, TRUE, TRUE),
    (4, FALSE, FALSE),
    (5, TRUE, FALSE),
    (6, FALSE, TRUE),
    (7, TRUE, TRUE),
    (8, FALSE, FALSE),
    (9, TRUE, FALSE),
    (10, FALSE, TRUE)
ON CONFLICT DO NOTHING;

-- Insert customers
INSERT INTO customer (customer_id, first_name, middle_name, last_name, address_id, privacy_settings_id)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'Alice', NULL, 'Smith', 1, 1),
    ('22222222-2222-2222-2222-222222222222', 'Bob', 'J', 'Jones', 2, 2),
    ('33333333-3333-3333-3333-333333333333', 'Charlie', NULL, 'Brown', 3, 3),
    ('44444444-4444-4444-4444-444444444444', 'David', 'K', 'Miller', 4, 4),
    ('55555555-5555-5555-5555-555555555555', 'Emma', NULL, 'Davis', 5, 5),
    ('66666666-6666-6666-6666-666666666666', 'Frank', NULL, 'Wilson', 6, 6),
    ('77777777-7777-7777-7777-777777777777', 'Grace', 'L', 'Taylor', 7, 7),
    ('88888888-8888-8888-8888-888888888888', 'Hugo', NULL, 'Anderson', 8, 8),
    ('99999999-9999-9999-9999-999999999999', 'Isabel', NULL, 'Thomas', 9, 9),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Jack', 'M', 'Jackson', 10, 10)
ON CONFLICT DO NOTHING;

-- Insert customer emails
INSERT INTO customer_email (customer_id, email)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'alice@example.com'),
    ('22222222-2222-2222-2222-222222222222', 'bob@example.com'),
    ('33333333-3333-3333-3333-333333333333', 'charlie@example.com'),
    ('44444444-4444-4444-4444-444444444444', 'david@example.com'),
    ('55555555-5555-5555-5555-555555555555', 'emma@example.com'),
    ('66666666-6666-6666-6666-666666666666', 'frank@example.com'),
    ('77777777-7777-7777-7777-777777777777', 'grace@example.com'),
    ('88888888-8888-8888-8888-888888888888', 'hugo@example.com'),
    ('99999999-9999-9999-9999-999999999999', 'isabel@example.com'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'jack@example.com')
ON CONFLICT DO NOTHING;

-- Insert phone numbers
INSERT INTO customer_phone_number (customer_id, type, number)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'mobile', '+15555550101'),
    ('22222222-2222-2222-2222-222222222222', 'mobile', '+15555550102'),
    ('33333333-3333-3333-3333-333333333333', 'mobile', '+15555550103'),
    ('44444444-4444-4444-4444-444444444444', 'mobile', '+15555550104'),
    ('55555555-5555-5555-5555-555555555555', 'mobile', '+15555550105'),
    ('66666666-6666-6666-6666-666666666666', 'mobile', '+15555550106'),
    ('77777777-7777-7777-7777-777777777777', 'mobile', '+15555550107'),
    ('88888888-8888-8888-8888-888888888888', 'mobile', '+15555550108'),
    ('99999999-9999-9999-9999-999999999999', 'mobile', '+15555550109'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'mobile', '+15555550110')
ON CONFLICT DO NOTHING;

COMMIT;
```
```

## File: project_root/agentic-pipeline/tools/db-json_schema_to_sql_ddl.tool.md

```markdown
# tool - DB - JSON Schema to SQL DDL


## Context

Convert a JSON schema into normalized DDL SQL statements.  
Output Directory: `/db`

## Constraints**
- Use PostgreSQL v16 dialect
- Normalize to at least 3NF
- Use singular table names (e.g., customer, order_item)
- Include indexes for foreign keys and queryable fields
- Use CREATE TABLE IF NOT EXISTS
- Follow project naming conventions
- Replace NN in file path with incremented number. ie db/migrations/01_<domain>_.sql

## Inputs

- codex session context: Persisted Data schema

## Output  

- A complete SQL file with metadata header, table definitions, foreign keys, and indexes.
- File path: db/migrations/NN_<domain>_.sql

## Task  
Generate a migration in `db/migrations/NN_<schema title>_tables.sql` that:
- Creates normalized tables from the JSON schema referenced in ticket.
- Infers data types and constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE)
- Maps nested objects ie (`customer`, `shipping_address`) to separate tables
- Converts arrays (`items`) to a related table
- Creates a flattened views of the domain. 

## Workflow Outline

1. Review the DB task file to confirm conventions, timestamp rules, and required header fields.
2. Parse the customer JSON schema to derive an entity-relationship outline (e.g., `customer`, `customer_address`, `customer_contact`, etc.).
3. Draft SQL with all constraints and indexes (`btree` on foreign keys, `GIN` or `btree` on heavily-queried columns).

## Acceptance Criteria
* Expected Outputs were created.
* Each file contains a metadata header block.
* Uses `CREATE TABLE IF NOT EXISTS` statements valid for PostgreSQL 16.
* Implements all keys, constraints, and indexes required by the JSON schema.
* Naming conventions, timestamp format, and directory layout match project standards.
* `project_root/db/README.md` gains a short “Domain Migration” section describing how to execute the migration and smoke tests locally.

# Example Execution 

## Inputs

- codex session context: Persisted Data schema

## JSON Schema
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "CustomerProfile",
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the customer profile"
    },
    "firstName": {
      "type": "string",
      "minLength": 1,
      "description": "Customer’s given name"
    },
    "middleName": {
      "type": "string",
      "description": "Customer’s middle name or initial",
      "minLength": 1
    },
    "lastName": {
      "type": "string",
      "minLength": 1,
      "description": "Customer’s family name"
    },
    "emails": {
      "type": "array",
      "description": "List of the customer’s email addresses",
      "items": {
        "type": "string",
        "format": "email"
      },
      "minItems": 1,
      "uniqueItems": true
    },
    "phoneNumbers": {
      "type": "array",
      "description": "List of the customer’s phone numbers",
      "items": {
        "$ref": "#/definitions/PhoneNumber"
      },
      "minItems": 1
    },
    "address": {
      "$ref": "#/definitions/PostalAddress"
    },
    "privacySettings": {
      "$ref": "#/definitions/PrivacySettings"
    }
  },
  "required": [
    "id",
    "firstName",
    "lastName",
    "emails",
    "privacySettings"
  ],
  "additionalProperties": false,
  "definitions": {

    "PhoneNumber": {
      "type": "object",
      "properties": {
        "type": {
          "type": "string",
          "description": "Type of phone number",
          "enum": ["mobile", "home", "work", "other"]
        },
        "number": {
          "type": "string",
          "pattern": "^\\+?[1-9]\\d{1,14}$",
          "description": "Phone number in E.164 format"
        }
      },
      "required": ["type", "number"],
      "additionalProperties": false
    },
    "PostalAddress": {
      "type": "object",
      "properties": {
        "line1": {
          "type": "string",
          "minLength": 1,
          "description": "Street address, P.O. box, company name, c/o"
        },
        "line2": {
          "type": "string",
          "description": "Apartment, suite, unit, building, floor, etc."
        },
        "city": {
          "type": "string",
          "minLength": 1,
          "description": "City or locality"
        },
        "state": {
          "type": "string",
          "minLength": 1,
          "description": "State, province, or region"
        },
        "postalCode": {
          "type": "string",
          "description": "ZIP or postal code"
        },
        "country": {
          "type": "string",
          "minLength": 2,
          "maxLength": 2,
          "description": "ISO 3166-1 alpha-2 country code"
        }
      },
      "required": ["line1", "city", "state", "postalCode", "country"],
      "additionalProperties": false
    },
    "PrivacySettings": {
      "type": "object",
      "properties": {
        "marketingEmailsEnabled": {
          "type": "boolean",
          "description": "Whether the user opts in to marketing emails"
        },
        "twoFactorEnabled": {
          "type": "boolean",
          "description": "Whether two-factor authentication is enabled"
        }
      },
      "required": [
        "marketingEmailsEnabled",
        "twoFactorEnabled"
      ],
      "additionalProperties": false
    }
  }
}
````

**Expected Output

```sql
-- App: Initial Full-Stack Application
-- Package: db
-- File: 20250610120000_create_customer_profile_tables.sql
-- Version: 0.1.0
-- Author: AI Agent
-- Date: 2025-06-10
-- Description: Creates the customer_profile schema and normalized tables.

BEGIN;

-- 1. Ensure the schema exists
CREATE SCHEMA IF NOT EXISTS customer_profile;

-- 2. Work inside that schema for the rest of the script
SET search_path TO customer_profile, public;

/* ---------- Reference tables ---------- */
CREATE TABLE IF NOT EXISTS postal_address (
                                              address_id  SERIAL PRIMARY KEY,
                                              line1       VARCHAR(255) NOT NULL,
                                              line2       VARCHAR(255),
                                              city        VARCHAR(100) NOT NULL,
                                              state       VARCHAR(50)  NOT NULL,
                                              postal_code VARCHAR(20),
                                              country     CHAR(2)      NOT NULL
);

CREATE TABLE IF NOT EXISTS privacy_settings (
                                                privacy_settings_id      SERIAL  PRIMARY KEY,
                                                marketing_emails_enabled BOOLEAN NOT NULL,
                                                two_factor_enabled       BOOLEAN NOT NULL
);

/* ---------- Root entity ---------- */
CREATE TABLE IF NOT EXISTS customer (
                                        customer_id         UUID PRIMARY KEY,
                                        first_name          VARCHAR(255) NOT NULL,
                                        middle_name         VARCHAR(255),
                                        last_name           VARCHAR(255) NOT NULL,
                                        address_id          INT  REFERENCES postal_address(address_id),
                                        privacy_settings_id INT  REFERENCES privacy_settings(privacy_settings_id)
);

CREATE INDEX IF NOT EXISTS idx_customer_address_id
    ON customer (address_id);
CREATE INDEX IF NOT EXISTS idx_customer_privacy_settings_id
    ON customer (privacy_settings_id);

/* ---------- One-to-many collections ---------- */
CREATE TABLE IF NOT EXISTS customer_email (
                                              email_id    SERIAL PRIMARY KEY,
                                              customer_id UUID NOT NULL REFERENCES customer(customer_id) ON DELETE CASCADE,
                                              email       VARCHAR(255) NOT NULL,
                                              UNIQUE (customer_id, email)
);
CREATE INDEX IF NOT EXISTS idx_customer_email_customer_id
    ON customer_email (customer_id);

CREATE TABLE IF NOT EXISTS customer_phone_number (
                                                     phone_id    SERIAL PRIMARY KEY,
                                                     customer_id UUID NOT NULL REFERENCES customer(customer_id) ON DELETE CASCADE,
                                                     type        VARCHAR(20) NOT NULL,
                                                     number      VARCHAR(15) NOT NULL,
                                                     UNIQUE (customer_id, number)
);
CREATE INDEX IF NOT EXISTS idx_customer_phone_customer_id
    ON customer_phone_number (customer_id);

COMMIT;
```




```

## File: project_root/agentic-pipeline/tools/maven-replace_maven_pom_elements.tool.md

```markdown
## Tool: Replace Maven POM Elements

### Purpose

Given a Maven POM XML, replace only the text nodes of `<groupId>`, `<artifactId>`, `<name>`, and `<description>` with values from the Codex session context. Preserve XML structure, indentation, and tags exactly as-is.

---

### Inputs

Load Codex Project context.

---

### Example Run

**Provided Context:**

# Project

## Maven

- groupId: com.bobwares.customer
- artifactId: registration
- name: Customer Registration
- description: Spring Boot service for managing customer registrations


**Result:**

Response with update pom.xml with the following changes.


```xml
  <groupId>com.bobwares.customer</groupId>
  <artifactId>registration</artifactId>
  <name>Customer Registration</name>
  <description>Spring Boot service for managing customer registrations</description>
```

```

## File: project_root/agentic-pipeline/tools/persistence-generate_persistence_code.tool.md

```markdown
## Tool: Generate Persistence Code (Spring Data JPA for PostgreSQL)

### Purpose

Generate the Java persistence layer for a domain entity using Spring Data JPA on PostgreSQL. Produce compilable source that maps the project’s JSON schema to JPA entities, repositories, and a service layer, aligned with the Codex session context and existing DB migrations.

---

### Inputs

Load Codex session context.

* Project

    * Name
    * Author
* Maven

    * groupId
    * artifactId
* Domain

    * Domain Object (singular, e.g., Customer)
    * Persisted Data schema (path to JSON schema)
* Tech assumptions (implicit unless overridden)

    * Java 21, Spring Boot 3.5.x, Hibernate 6.x, PostgreSQL 16

---

### Constraints

* Use `jakarta.persistence.*` and `jakarta.validation.*`.
* Map JSON field names to snake\_case DB column names.
* Prefer `UUID` primary keys; use `@JdbcTypeCode(SqlTypes.UUID)` where applicable.
* Do not modify packages under `health`.
* Respect existing DDL generated by DB tools (do not rename tables/columns that would drift from migrations).
* `open-in-view: false` assumed; no lazy loading in controller layer required by this tool.

---

### Behavior

1. Parse the Persisted Data schema to derive entity fields, nullability, lengths, uniques, and FKs.
2. Emit:

    * A JPA `@Entity` with `@Table`, `@Column`, PK, and FK mappings.
    * A Spring Data `JpaRepository<Entity, IdType>`.
    * A Service class with transactional CRUD and simple uniqueness guards (where indicated by schema).
    * Optional mappers/DTOs only if the schema requires value-object flattening for aggregates.
3. Maintain alignment with prior DB migrations (table names, column names, constraints).
4. Generate null-safe getters and validation annotations consistent with schema.

---

### Deliverables (create or update)

* `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}.java`

    * `@Entity`, `@Table(name = "<table_name>")`
    * Fields from schema with `@Column(name = "...", nullable = ..., length = ...)`
    * PK: `UUID id` with `@Id`, `@GeneratedValue`, `@JdbcTypeCode(SqlTypes.UUID)`
    * Timestamps (if not in schema): `created_at`, `updated_at` via `@CreationTimestamp`, `@UpdateTimestamp` (optional)
    * Unique constraints as `@UniqueConstraint` or column-level `unique = true` when appropriate
    * Relationships mapped via `@ManyToOne`, `@OneToMany`, etc., only if indicated by schema
* `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Repository.java`

    * `interface {{Domain}}Repository extends JpaRepository<{{Domain}}, UUID>`
    * Convenience finders inferred from unique fields (e.g., `findByEmail`, `existsByEmail`)
* `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Service.java`

    * Methods: `create`, `get`, `list`, `update`, `delete`
    * `@Transactional` boundaries; uniqueness validation prior to writes
    * Converts to/from simple DTOs when required; otherwise returns entity
* (Optional) DTOs if schema types or nested objects benefit from separation:

    * `.../api/{{Domain}}Dto.java` with `CreateRequest`, `UpdateRequest`, `Response`

Where `{{groupIdPath}}` is `{{groupId}}` with dots replaced by slashes.

---

### Mapping Rules

* JSON `string` → Java `String` (apply `@Size(max = n)` if `maxLength` present)
* JSON `string (format: uuid)` → Java `UUID` with `@JdbcTypeCode(SqlTypes.UUID)`
* JSON `boolean` → `Boolean`/`boolean`
* JSON numeric types → `Integer`, `Long`, `BigDecimal` based on `format`/range hints when present
* Required fields → `@NotNull`/`@NotBlank` (text) and `nullable = false` in `@Column`
* `enum` → `@Enumerated(EnumType.STRING)` with generated `enum` type in same package
* Arrays/collections in schema → separate child entity mapped `@OneToMany` with FK, only if the DB DDL establishes a separate table
* Email fields → add `@Email` when field name or schema format indicates email

---

### Output Format

On success, return a JSON object with file list and contents suitable for writing to disk:

```json
{
  "status": "success",
  "files": [
    {"path": "src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}.java", "content": "..."},
    {"path": "src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Repository.java", "content": "..."},
    {"path": "src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Service.java", "content": "..."}
  ]
}
```

On failure:

```json
{
  "status": "failure",
  "error": "reason message"
}
```

---

### Workflow

1. Load Codex session context.
2. Read Persisted Data schema.
3. Determine PK, uniques, nullability, lengths, and relationships from schema (and, if present, `x-db.*` hints).
4. Render Java sources using the mapping rules and constraints.
5. Validate that generated names and types match existing DB DDL conventions (if DB tool artifacts are available).
6. Emit output files.

---

### Acceptance Criteria

* Code compiles under Java 21 and Spring Boot 3.5.x with JPA/Hibernate 6.
* Entity/table/column names match DB migrations (no drift).
* Required fields enforced via annotations and column nullability.
* Repository provides at least one convenience finder for unique fields.
* Service methods are transactional and enforce uniqueness where specified.
* No changes to non-persistence packages (e.g., `health`) are made.

---

### Example Invocation (from context)

* Domain Object: `Customer`
* Persisted Data schema: `project_root/ai/agentic-pipeline/context/schemas/customer.schema.json`
* Maven:

    * groupId: `com.bobwares.customer`
    * artifactId: `registration`

Expected files under:

* `src/main/java/com/bobwares/customer/registration/Customer.java`
* `src/main/java/com/bobwares/customer/registration/CustomerRepository.java`
* `src/main/java/com/bobwares/customer/registration/CustomerService.java`

```

## File: project_root/agentic-pipeline/tools/rest-generate_rest_api.tool.md

```markdown
# Tool – Generate CRUD with OpenAPI, Unit Tests, and E2E HTTP (Spring MVC + JPA + Postgres)

## Role
You are an expert Java Spring Boot engineer. Implement synchronous CRUD endpoints for a domain object backed by **Spring Data JPA** on **PostgreSQL**. Produce code, tests, and an E2E `.http` file. Conform to repository metadata/versioning rules.

## Inputs
codex_session_context variables.

### Project
- Name, Detailed Description, Author

### Maven
- groupId
- artifactId
- name
- description

### Domain
- Domain Object (singular)
- Persisted Data schema (source of truth for fields, nullability, uniques, relationships)

## Objectives
1. Create a **Spring MVC** REST API in package `{{groupId}}.{{artifactId}}` for `{{Domain Object}}`.
2. Persist using **Spring Data JPA** mapped to PostgreSQL tables defined by the schema/DDLs.
3. Annotate endpoints with **springdoc OpenAPI**.
4. Validate input via **Jakarta Bean Validation**.
5. Provide **unit tests** (service/repository) and **integration tests** (controller) against a real Postgres (Testcontainers if available, else local profile).
6. Provide an `.http` file covering create → read → update → delete E2E.

## Non-functional Constraints
- Java 21, Spring Boot 3.5.x, **Spring MVC** (`spring-boot-starter-web`).
- Persistence with **JPA/Hibernate** (`spring-boot-starter-data-jpa`) + PostgreSQL driver.
- OpenAPI via `springdoc-openapi-starter-webmvc-ui`.
- Do not modify code under package `health`.
- Use `open-in-view: false`; service layer encapsulates transactions.
- Respect existing DDL/table/column names; no schema drift.

## Deliverables (create or update)
1) Domain + Persistence
- `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}.java`
  - `@Entity`, `@Table(name="<table_name>")`
  - Fields from schema with `@Column(name="...", nullable=..., length=...)`
  - Primary key: prefer `UUID` with `@Id`, `@GeneratedValue`, `@JdbcTypeCode(SqlTypes.UUID)`
  - Uniques via `@UniqueConstraint` or `unique = true`
  - FKs via `@ManyToOne`, `@OneToMany` only if indicated by schema

- `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Repository.java`
  - `interface {{Domain}}Repository extends JpaRepository<{{Domain}}, UUID>`
  - Convenience finders for unique fields (e.g., `findByEmail`)

- `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Service.java`
  - `@Service`, `@Transactional`
  - Methods: `create`, `get`, `list`, `update`, `delete`
  - Enforce uniqueness where schema requires (e.g., email)

2) API
- `src/main/java/{{groupIdPath}}/{{artifactId}}/api/{{Domain}}Dto.java`
  - `CreateRequest`, `UpdateRequest`, `Response` with bean validation

- `src/main/java/{{groupIdPath}}/{{artifactId}}/api/{{Domain}}Controller.java`
  - `@RestController`, `@RequestMapping("/api/{{Domain}}s")`
  - Methods: POST create(201), GET by id(200), GET list(200), PUT update(200), DELETE(204)

- OpenAPI annotations:
  - `@Tag`, `@Operation`, `@ApiResponses`, `@Parameter`, `@RequestBody`
  - Ensure models appear correctly in generated docs

3) Error Handling
- `src/main/java/{{groupIdPath}}/{{artifactId}}/web/RestExceptionHandler.java`
  - Map `EntityNotFoundException` → 404, `IllegalArgumentException`/validation → 400/422

4) Tests
- Unit: `src/test/java/.../{{Domain}}ServiceTests.java`
  - Create/get/update/delete happy paths; uniqueness violation

- Integration: `src/test/java/.../{{Domain}}ControllerIT.java`
  - `@SpringBootTest(webEnvironment=RANDOM_PORT)` + `@AutoConfigureMockMvc` or `@AutoConfigureWebTestClient`
  - Backed by **Testcontainers Postgres** if dependency present; else assume local profile env
  - Assert statuses/payloads; full CRUD flow

5) E2E HTTP
- `e2e/{{Domain}}.http`
  - POST → capture `id`
  - GET by `id`
  - PUT update
  - DELETE
  - GET (expect 404)

> `{{groupIdPath}}` = `{{groupId}}` with dots replaced by slashes.

## Implementation Details

### Mapping Rules
- JSON `string` → Java `String` (`@Size(max=n)` if `maxLength`)
- JSON `string(format: uuid)` → `UUID` + `@JdbcTypeCode(SqlTypes.UUID)`
- Required → `@NotNull`/`@NotBlank` and `nullable=false`
- `enum` → Java `enum` + `@Enumerated(EnumType.STRING)`
- Arrays needing tables → separate child entity only if present in DDL/schema

### OpenAPI
- Add `org.springdoc:springdoc-openapi-starter-webmvc-ui` to POM if missing.
- UI should be available at `/swagger-ui.html`.

### Testing Notes
- If `org.testcontainers:postgresql` is on classpath, use it:
  - Start container in a static initializer or `@TestConfiguration`
  - Expose JDBC URL/creds to Spring context
- Otherwise, require `application-local.yml` with env-driven creds and instruct to run tests with `-Dspring.profiles.active=local`.

## E2E HTTP File Requirements
- `@host = http://localhost:{{PORT:8080}}`
- JSON payloads reflect DTOs (snake_case to match API contract if used; otherwise standard camelCase)
- Sequence: POST → GET → PUT → DELETE → GET(404)

## Output Format
Provide only the files listed above, each with the standard metadata header. Do not include binaries.

## Acceptance Criteria
- Compiles on Java 21; Spring Boot 3.5.x.
- Entities, repository, and service align with existing DDL; no naming drift.
- CRUD endpoints pass integration tests (Testcontainers or local DB).
- OpenAPI renders models and endpoints accurately.
- `.http` scenario executes end-to-end successfully.

```

