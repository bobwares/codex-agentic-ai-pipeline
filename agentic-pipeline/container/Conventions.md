# Agentic Pipeline Conventions

> **Purpose** – A single source of truth for naming, templating, file layout, branching, and formatting rules used by every turn of the Codex Agentic AI Pipeline.

---

## 1. Variable & Templating Syntax

| Syntax | Meaning | Resolved When | Example |
|--------|---------|---------------|---------|
| `${VAR}` | **Early-bound** – value known **before** the turn starts (from `session_context.md` or environment) | Session-load time | `${TURN_ID}`, `${TARGET_PROJECT}`, `${ACTIVE_PATTERN_PATH}` |
| `{{VAR}}` | **Late-bound** – placeholder filled **at render time** by the templating engine | File-generation time | `{{DATE}}`, `{{TIME_OF_EXECUTION}}`, `{{COMMIT_HASH}}` |

*Use `${…}` for static configuration, `{{…}}` for runtime/dynamic values.*
