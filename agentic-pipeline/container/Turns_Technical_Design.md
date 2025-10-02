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

4. **Commit & tag**

    * Commit with conventional message and the Turn ID.
    * Tag `turn/<TurnID>`.
    * Optionally open a PR referencing the Turn ID.

    
## Indexing

Append one line per turn to `/turns/index.csv`:

```
turnId,timestampUtc,task,branch,tag,headAfter,testsPassed,testsFailed,coverageDeltaPct
1,2025-09-05T17:42:10Z,generate-controllers-and-services,turn/1,turn/1,d4e5f6a,42,0,1.8
```


