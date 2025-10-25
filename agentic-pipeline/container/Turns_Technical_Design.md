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


## Change Log

- Append the change log for each “AI turn” in: project_root/ai/agentic-pipeline/turns/current turn directory/changelog.md
- record the following in the changelog.md
  - Record the input prompt.
  - List each task_name executed during a turn.  
  - List each tool_name executed during a task.
  - List each agent_name executed during a task.
  - List each path/file_name added during the task.
  - List each path/file_name updated during the task.  
  - Use the template: {{TEMPLATE_CHANGELOG}}


## ADR (Architecture Decision Record)

Read and execute /workspace/codex-agentic-ai-pipeline/agentic-pipeline/container/Architecture_Decision_Record.md


## manifest.json (authoritative index)

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
- Read task and execute the specified tasks in the selected application implementation pattern's task-pipeline.md.
- Resolve inputs (variables, task, domain schema, constraints).
- Create Change Log.
- Create ADR (Architecture Decision Record).
- Create `/turns/<TurnID>/manifest.json` with initial metadata.
- Update `manifest.json` (hashes, file list, metrics).
- Write global and project scoped variable values to session_context_values.md in the current turn directory.
- Create/update Turn Index.
- execute task project_root/agentic-pipeline/container/tasks/TASK - Create Project Markdown File.task.md when code generation has completed.



