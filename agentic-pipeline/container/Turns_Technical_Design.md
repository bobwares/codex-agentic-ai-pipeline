# Turns: Technical Design

## Core definitions

* **Turn**: a single execution of a Codex task (plan, generate, refactor, test, etc).
* **Turn ID**: a monotonically increasing integer. Initial value `1`. Incremented by `1` at the start of each new turn.


    
## Turn Index

Append one line per turn to `/ai/agentic-pipeline/turns_index.csv`:

```
turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
```

## Logging

### Change Log

- Append the change log for each “AI turn” in: project_root/ai/agentic-pipeline/turns/current turn directory/changelog.md
- record the following in the changelog.md
  - Record the input prompt.
  - List each task_name executed during a turn.  
  - List each tool_name executed during a task.
  - List each agent_name executed during a task.
  - List each path/file_name added during the task.
  - List each path/file_name updated during the task.  
  - Use the following template


```
    # Turn: {{turn number}}  – {{Date}} - {{Time of execution}}
    
    ## Statement of Work
   
    {{ generate a description of the work complete during the task. }}
    
    --
    ## Input Prompt

    {{ input prompt}}

    -- 
    ## Tasks Executed
    - {{task name executed during a turn}}
     - {{tools/agents that are execute during a task.}}
    
    ## Turn Tracking Files Added
    List: all path/file_name added under the /ai directory
    
     ## Files Added
    Table: all path/file_name added. exclude path/file_name added under the /ai directory :: col1 path/file_name col2 task_name that created the file.
   
    
    ## Files Updated
    Table: all path/file_name added. exclude path/file_name added under the /ai directory :: col1 path/file_name col2 task_name that created the file.
   
    
    
   
```

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

**Options Considered**
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


## Turns lifecycle

- Allocate next Turn ID (increment integer).
- load session and project contexts
- Read task and executes the specified tasks in the selected application implementation pattern's task-pipeline.md..
- Resolve inputs (variables, task, domain schema, constraints).
- Create Change Log.
- Create ADR (Architecture Decision Record).
- Create `/turns/<TurnID>/manifest.json` with initial metadata.
- Update `manifest.json` (hashes, file list, metrics).
- Write global and project scoped variable values to session_context_values.md in the current turn directory.
- Create/update Turn Index.
- execute task project_root/agentic-pipeline/container/tasks/TASK - Create Project Markdown File.task.md when code generation has completed.
