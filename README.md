# Codex Agentic Pipeline

## Overview


The **Codex Agentic Pipeline** is a modular, iterative framework designed for the Codex environment (powered by models like ChatGPT or Grok) to enable agentic software development. It orchestrates AI-driven code generation, testing, and deployment through a series of "turns," where each turn represents a discrete execution cycle. The pipeline emphasizes reproducibility, traceability, and standardization by integrating tools, tasks, metadata headers, semantic versioning, changelogs, and Architecture Decision Records (ADRs).

This project is particularly suited for generating production-grade applications using predefined patterns (e.g., Spring Boot MVC with JPA and PostgreSQL). It separates orchestration logic from generated artifacts, ensuring that the target project's code is compliant with coding standards while maintaining a clean separation of concerns.

### Key Features
- **Iterative "Turns"**: Each execution is a self-contained turn with inputs, outputs, logs, and artifacts.
- **Modular Tasks and Tools**: Reusable components for operations like DDL generation, persistence layer creation, and REST API development.
- **Metadata and Versioning**: Enforces headers in generated files for traceability; uses semantic versioning starting at `0.1.0`.
- **Logging and Documentation**: Automatic changelogs and ADRs for every significant change.
- **Patterns-Based Generation**: Supports application implementation patterns (e.g., Spring Boot MVC JPA PostgreSQL) for consistent architecture.
- **Sandbox Integration**: The pipeline is copied into a sandbox within the target repository, with symbolic links to key files like `AGENTS.md` for standard enforcement.
- **Reproducibility**: Persistent history of turns, including manifests, diffs, and reports.
- **Tech Stack Agnostic**: Extendable to various stacks via patterns, with built-in support for Java/Spring Boot, PostgreSQL, and more.

### Goals
- Ensure every Codex execution is reproducible and auditable.
- Enforce metadata, versioning, and documentation standards in generated code.
- Provide traceability through changelogs, ADRs, and manifests.
- Support modular, extensible pipelines that scale with project complexity.
- Facilitate agentic workflows where AI agents can plan, execute, and reflect on software development tasks.

## Concepts

### Turns
A **turn** is the fundamental unit of execution in the pipeline:
- Represents one iteration of a Codex task (e.g., planning, generating code, refactoring, testing).
- Identified by a unique **Turn ID** (monotonically increasing integer, starting at 1).
- Produces artifacts: changelog, ADR, manifest, logs, diffs, and reports.
- Lifecycle: Plan → Execute → Record → Commit & Tag.
- Stored in `/ai/agentic-pipeline/turns/<TurnID>/` with subdirectories for inputs, outputs, logs, and artifacts.

### Tasks
- A **task** is a prompt or workflow unit executed by Codex.
- Defined in `/ai/agentic-pipeline/patterns/<pattern>/tasks/` as Markdown (e.g., `*.task.md`), YAML, or JSON.
- Modular and reusable; can chain tools (e.g., `create_app.task.md` executes subtasks like `initialize_app.task.md` and `create_rest_service.task.md`).
- Examples: `create_persistence_layer.task.md` (generates JPA entities), `generate_normalized_tables_from_json_schema.task.md` (creates SQL DDL).

### Tools
- **Tools** are reusable operations invoked by tasks.
- Defined in `/ai/agentic-pipeline/patterns/<pattern>/tools/` as Markdown (e.g., `*.tool.md`).
- Encapsulate specific functions like SQL DDL generation, test data creation, or Maven POM updates.
- Examples: `db-json_schema_to_sql_ddl.tool.md` (converts JSON schema to PostgreSQL DDL), `rest-generate_rest_api.tool.md` (creates Spring MVC controllers with OpenAPI).

### Orchestration (`AGENTS.md`)
- Central configuration file defining how tasks and tools are chained.
- Enforces coding standards, metadata headers, and versioning for generated files.
- Guides Codex in interpreting user requests and selecting appropriate tools/patterns.

### Patterns
- Predefined application architectures loaded into the session context.
- Located in `/ai/agentic-pipeline/patterns/<pattern>/` (e.g., `spring-boot-mvc-jpa-postgresql`).
- Include tech stack details, configuration templates (e.g., `application.yml`, `.gitignore`), tasks, and tools.
- Loaded via `codex_session_context.md` for context-specific generation.

## Repository Layout

The pipeline repository is structured to separate context, patterns, tasks, tools, and turn history:

```
project_root/
├── AGENTS.md                  # Orchestration and coding standards
├── ai/
│   ├── agentic-pipeline/
│   │   ├── context/           # Core definitions and contexts
│   │   │   ├── Agentic_Pipeline_Definition.md
│   │   │   ├── Turns_Technical_Design.md
│   │   │   ├── codex_session_context.md
│   │   ├── patterns/
│   │   │   ├── spring-boot-mvc-jpa-postgresql/
│   │   │   │   ├── spring-boot-mvc-jpa-postgresql.pattern.md
│   │   │   │   ├── tasks/     # Pattern-specific tasks
│   │   │   │   │   ├── create_app.task.md
│   │   │   │   │   ├── create_configuration_files.task.md
│   │   │   │   │   ├── create_persistence_layer.task.md
│   │   │   │   │   ├── create_rest_service.task.md
│   │   │   │   │   ├── generate_normalized_tables_from_json_schema.task.md
│   │   │   │   │   └── initialize_app.task.md
│   │   │   │   └── tools/     # Pattern-specific tools
│   │   │   │       ├── create_configuration_files.tool.md
│   │   │   │       ├── db-create_test_data_for_schema.tool.md
│   │   │   │       ├── db-json_schema_to_sql_ddl.tool.md
│   │   │   │       ├── maven-replace_maven_pom_elements.tool.md
│   │   │   │       ├── persistence-generate_persistence_code.tool.md
│   │   │   │       └── rest-generate_rest_api.tool.md
│   │   ├── turns/             # Turn history
│   │   │   ├── index.csv      # Registry of all turns
│   │   │   └── <timestamp>_turn-<id>/  # Per-turn directory
│   │   │       ├── inputs/
│   │   │       ├── outputs/
│   │   │       ├── logs/
│   │   │       ├── artifacts/
│   │   │       ├── manifest.json
│   │   │       ├── changelog.md
│   │   │       ├── adr.md
│   │   │       └── diff.patch
│   └── ...                    # Additional patterns or contexts as needed
└── changelog.md               # Project-level changelog (appends from per-turn changelogs)
```

When integrated into a target project:
- The entire `agentic-pipeline` is copied into a sandbox directory (e.g., `target_repo/sandbox/ai/agentic-pipeline/`).
- A symbolic link is created to `AGENTS.md` in the target repo's root for easy reference.

## Metadata Standards

Metadata headers are **required only for target generated code** (source, test, IaC files, excluding `pom.xml`). They provide traceability and must be placed at the top of each file.

### Header Template
Adapt syntax to file type (e.g., `/** ... */` for Java, `-- ...` for SQL, `# ...` for YAML).

```
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
```

### Versioning Rules
- Use semantic versioning (`MAJOR.MINOR.PATCH`).
- Start at `0.1.0`; increment only on content changes.
- Update version in headers during turns if the file is modified.

## Coding Standards

- **Generated Files**: All target source, test, and IaC files (except `pom.xml`) must include metadata headers.
- **SQL**: Use PostgreSQL v16 dialect; normalize to 3NF; singular table names; idempotent statements (e.g., `CREATE TABLE IF NOT EXISTS`); include indexes for FKs.
- **Java**: Use Java 21, Spring Boot 3.5.x; follow mapping rules (e.g., snake_case columns, UUID PKs).
- **Configuration**: Environment variables in `application.yml` without defaults; validate via `@ConfigurationProperties`.
- **Tests**: Unit and integration tests; use Testcontainers for PostgreSQL if available.
- **OpenAPI**: Annotate endpoints for auto-generated docs.
- **Error Handling**: Centralized handlers for exceptions (e.g., 404 for not found).

For full details, see `AGENTS.md` (symbolically linked in target repos).

## Logging

### Change Log
- Per-turn: Stored in `/ai/agentic-pipeline/turns/<TurnID>/changelog.md`.
- Project-level: Append to `project_root/changelog.md`.
- Tracks tasks, tools, changes, migrations, SemVer impact, risks, and linked artifacts.

#### Entry Template
```
# Turn: {{turn number}}  – {{Date Time of execution}}

## prompt
{{ input prompt}}

#### Task
<Task>

#### Changes
- Initial project structure and configuration.

### 0.1.0 – 2025-09-14 18:39:05 UTC

#### Task
<Task>

#### Changes
- Add tsconfig for ui and api.
- Create src directories with unit-test folders.
```

### ADR (Architecture Decision Record)
- Stored in `/ai/agentic-pipeline/turns/<TurnID>/adr.md`.
- Required for non-obvious decisions (e.g., library choices, layout changes).
- Not required for trivial/cosmetic changes.

#### Template
```
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

## Environment Setup

1. **Copy Pipeline to Sandbox**:
    - Copy the entire `codex-agentic-pipeline` repository into a sandbox directory in the target project (e.g., `target_repo/sandbox/ai/agentic-pipeline/`).
    - This provides Codex with the necessary context (patterns, tasks, tools) without polluting the target repo's root.

2. **Symbolic Link to `AGENTS.md`**:
    - Run a setup script to create a symbolic link: `ln -s sandbox/ai/agentic-pipeline/AGENTS.md target_repo/AGENTS.md`.
    - This ensures the target project references the pipeline's coding standards directly.

3. **Select Pattern**:
    - Set an environment variable or config to select a pattern (e.g., `PATTERN=spring-boot-mvc-jpa-postgresql`).
    - Load via `codex_session_context.md`.

4. **Dependencies**:
    - Ensure Codex environment has access to the sandbox.
    - No additional installations needed; use built-in tools for generation.

Example Setup Script (`setup-sandbox.sh`):
```bash
#!/bin/bash

# Copy pipeline to sandbox
cp -r /path/to/codex-agentic-pipeline target_repo/sandbox/ai/agentic-pipeline

# Create symbolic link to AGENTS.md
ln -s target_repo/sandbox/ai/agentic-pipeline/AGENTS.md target_repo/AGENTS.md

echo "Sandbox setup complete. Symbolic link to AGENTS.md created."
```

## Workflow

1. **Start a Turn**:
    - Increment Turn ID in `/turns/index.csv`.
    - Create turn directory: `/turns/<timestamp>_turn-<id>/`.
    - Resolve inputs (e.g., domain schema, constraints).

2. **Execute Task**:
    - Select task based on user request (e.g., "create CRUD module").
    - Codex runs the task, invoking tools as needed (e.g., DDL generator, persistence code generator).

3. **Generate Outputs**:
    - Store results in `outputs/`.
    - Capture logs in `logs/` (e.g., LLM prompts/responses).

4. **Record Artifacts**:
    - Write `manifest.json` (indexes changes, metrics, validation).
    - Update changelog and ADR.
    - Compute diffs and reports.

5. **Commit and Tag**:
    - Commit with conventional message including Turn ID.
    - Tag as `turn/<TurnID>`.
    - Optionally open a PR.

## Example Pipeline Flow

**User Request**: "Generate a CRUD API for Customer domain using Spring Boot."

1. Load pattern: `spring-boot-mvc-jpa-postgresql`.
2. Start Turn 1.
3. Execute `create_app.task.md`:
    - Run `initialize_app.task.md` (update POM via `maven-replace_maven_pom_elements.tool.md`).
    - Run `create_configuration_files.task.md` (generate `.gitignore`, `application.yml` via tool).
    - Run `create_sql_ddl_from_schema.task.md` (use `db-json_schema_to_sql_ddl.tool.md` for DDL, `db-create_test_data_for_schema.tool.md` for data).
    - Run `create_persistence_layer.task.md` (generate JPA entities/repositories via tool).
    - Run `create_rest_service.task.md` (generate controllers/DTOs via `rest-generate_rest_api.tool.md`).
4. Record artifacts: changelog, ADR, manifest.
5. Commit and tag.

Generated files include metadata headers, e.g., in `CustomerController.java`:
```java
/**
 * App: Customer Registration
 * Package: com.bobwares.customer.registration.api
 * File: CustomerController.java
 * Version: 0.1.0
 * Turns: [1]
 * Author: Codex Agent
 * Date: 2025-09-14T18:39:05Z
 * Exports: createCustomer, getCustomer, etc.
 * Description: REST controller for Customer CRUD operations.
 */
```

## Git Integration

- **Branch Naming**: `turn/<TurnID>[-<task>]`.
- **Commit Message**:
  ```
  turn: <TurnID> <task> [scope]

  - Summary of changes
  - Key decisions: ADR#<TurnID>
  - Affected modules: <paths>
  - Tests: <added/updated status>

  Co-authored-by: Codex Agent <agent@local>

  Turn-Id: <TurnID>
  Turn-Task: <task>
  Turn-Metrics-FilesChanged: <count>
  ```
- **Tags**: `turn/<TurnID>` on merge to main.
- **CI Policy**: Validate `manifest.json`, ADR/changelog presence, lint/tests; fail on missing artifacts.


## Contributing

1. Fork the repository.
2. Create a branch: `git checkout -b feature/new-pattern`.
3. Add tasks/tools/patterns as needed.
4. Ensure all generated examples comply with standards.
5. Submit a PR with a turn simulation (manual changelog/ADR).

