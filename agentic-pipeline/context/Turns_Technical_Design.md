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
