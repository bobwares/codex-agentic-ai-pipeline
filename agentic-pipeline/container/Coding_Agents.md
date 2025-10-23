# Coding Agents


- Coding Agents are located in the directory project_root/Agents.  
- when a task executes a coding agent call, this is what happens:

```text
agent run sql-ddl-generator --dialect postgresql --schema-path ./schemas/domain.json --out-dir ./generated/sql
```

1. Coding agent loads the AGENTS.md from the codex-agentic-ai-pipeline/Agents/sql-ddl-generator directory.
2. The coding agent loads and executes the task-pipeline.md in the codex-agentic-ai-pipeline/Agents/sql-ddl-generator directory.