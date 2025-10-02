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

```

## Turn lifecycle

Each turn executes the specified tasks in the pattern.  


1. **Plan**

    * Resolve inputs (task, domain schema, constraints).
    * Allocate next Turn ID (increment integer).
    * Create `/turns/<TurnID>/manifest.json` with initial metadata.

2. **Execute**

    * Run tools (e.g., codegen, tests).
    * Capture logs, diffs, generated files.

3. **Record**

    * Write Change Log (human-readable delta).
    * Write ADR (Architecture Decision Record) (context, options, decision, consequences).
    * Finalize `manifest.json` (hashes, file list, metrics).
    * Write global and project scoped variable values to session_context_values.md in the current turn directory.

4. **Execute Post Turn Tasks**

    * project_root/agentic-pipeline/container/tasks/TASK - Create Project Markdown File.tas

   

    
## Indexing

Append one line per turn to `/turns/index.csv`:

```
turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
```

## Logging

### Change Log

- Track changes each “AI turn” in: project_root/ai/agentic-pipeline/turns/current turn directory/changelog.md
- append changes to project change log located project_root/changelog.md
- record the list of tasks and tools executed.

#### Change Log Entry Template

    # Turn: {{turn number}}  – {{Date}} - {{Time of execution}}
    
    ## Prompt

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


### ADR (Architecture Decision Record)

#### Purpose

The adr.md` folder captures **concise, high-signal Architecture Decision Records** whenever the
AI coding agent (or a human) makes a non-obvious technical or architectural choice.
Storing ADRs keeps the project’s architectural rationale transparent and allows reviewers to
understand **why** a particular path was taken without trawling through commit history or code
comments.

#### Location

    project_root/ai/agentic-pipeline/turns/current turn directory/adr.md


#### When the Agent Must Create an ADR

| Scenario                                                     | Example                                                                                                                                                                                                                                                                | Required? |
|--------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| Summarize Chain of Thought reasoning for the task            | Documenting the decision flow: ① capture requirements for a low-latency, pay-per-request CRUD API → ② compare DynamoDB single-table vs. Aurora Serverless → ③ choose DynamoDB single-table with GSI on email for predictable access patterns and minimal ops overhead. | **Yes**   |
| Selecting one library or pattern over plausible alternatives | Choosing Prisma instead of TypeORM                                                                                                                                                                                                                                     | **Yes**   |
| Introducing a new directory or module layout                 | Splitting `customer` domain into bounded contexts                                                                                                                                                                                                                      | **Yes**   |
| Changing a cross-cutting concern                             | Switching error-handling strategy to functional `Result` types                                                                                                                                                                                                         | **Yes**   |
| Cosmetic or trivial change                                   | Renaming a variable                                                                                                                                                                                                                                                    | **Yes**   |


#### ADR Template

```markdown
# Architecture Decision Record

{{ADR Title}}

**Turn**: {{current turn id}}

**Status**: Proposed | Accepted | Deprecated

**Date**: {{YYYY-MM-DD}} - {{hh:mm}}

**Context**  
Briefly explain the problem or decision context.

**Options Considered***
What are the options that were considered before implementing the solution.

**Decision**  
State the choice that was made. Explain how the decision was effected by the application implementation pattern context.


**Result**
What artifacts were created because of the decision.

**Consequences**  
List the trade-offs and implications (positive and negative).  
```

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






### Git Workflow Conventions

#### 1. Branch Naming

```
<type>/<short-description>-<Task-id?>
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

1. One branch per Task or atomic change.
2. **Never** commit directly to `main` or `develop`.
3. Re-base on the target branch before opening a pull request.

---

#### 2. Commit Messages (Conventional Commits)

```
AI Coding Agent Change:
<type>(<optional-scope>): <short imperative summary>
<BLANK LINE>
Optional multi-line body (wrap at 72 chars).
<BLANK LINE>
Refs: <Task-id(s)>
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

#### 3. Pull-Request Summary Template

Copy this template into every PR description and fill in each placeholder.

```markdown
# Summary
<!-- One-sentence description of the change. -->

# Details
* **What was added/changed?**
* **Why was it needed?**
* **How was it implemented?** (key design points)

# Related Tasks
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


