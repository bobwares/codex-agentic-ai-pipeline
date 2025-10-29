# Coding Agents


- A coding agents are specialized code generators.

- Coding Agents are located in the ${CODING_AGENTS_DIRECTORY}/{{Coding Agent Name}}.  

- when a task executes a coding agent call, this is what happens:

```text
agent run sql-ddl-generator --dialect postgresql --schema-path ./schemas/domain.json --out-dir ./generated/sql
```

1. The Coding agent definition is contained in the agents_context.md 
2. from the codex-agentic-ai-pipeline/Agents/sql-ddl-generator directory.
2. The coding agent loads and executes its execution-plan.md in the ${CODING_AGENTS_DIRECTORY}/{{Coding Agent Name}}/tasks directory.