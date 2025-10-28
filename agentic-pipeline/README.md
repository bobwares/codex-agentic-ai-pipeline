# Agentic Pipeline Artifacts

Each Codex turn must materialize a consistent set of governance artifacts under `ai/agentic-pipeline/turns/<turn-id>` so future
agents can audit prior context and continue the workflow safely.

## Required turn files

2. `adr.md` – Captures the key architectural decision(s) and their consequences.
3. `manifest.json` – Machine-readable index that points to every artifact and reports validation results.
4. `pull_request_body.md` – Rendered from the pull request template so the final PR message is reproducible.
5. `session_context_values.md` – Snapshot of all resolved session variables (sandbox paths, pattern, turn ID, template roots).

Populate `manifest.json` with relative paths to the other artifacts so downstream automation can locate them without guessing.

## Session context capture

Write `session_context_values.md` as a Markdown table listing each exported variable, the resolved value, and any helpful notes
about how the value was derived. The table should at least cover the environment, project, pattern, turn, and template variables
described in the shared session context documentation.

## Turn index 

If you maintain a `ai/agentic-pipeline/turns_index.csv`, append a row per turn recording the turn ID, timestamp, task focus, git
branch/tag, resulting commit, and testing outcomes. This provides a lightweight audit trail for the program managers.