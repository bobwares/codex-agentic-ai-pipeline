# Codex Agentic AI Pipeline — Container Definition 
Purpose: a reproducible runtime that executes agentic pipelines (“turns”), enforces project/session context, and runs the bundled application “Code Generator.”



## 1) Responsibilities

1. Orchestrate turns: allocate Turn IDs, scaffold per-turn artifacts (manifest, ADR, changelog, logs/reports), and enforce CI/validation gates.&#x20;
2. Load and expose the active contexts to tools and tasks:

    * Session context: `agentic-pipeline/context/codex_session_context.md`.
    * Project context: `AGENTS.md` + pattern docs and tasks in `agentic-pipeline/patterns/...`.&#x20;
3. Ship and run the “Code Generator” app (CLI first) that implements the turn lifecycle (`codex-turn init|run|record|finalize`) and writes artifacts under `/turns/<TurnID>/`.&#x20;
4. Provide a stable filesystem/API contract so tools can read inputs and write outputs at well-known paths.&#x20;

## 2) Core Components (inside the container)

* Context Loader

    * Reads session context and ensures the selected pattern is loaded into the project context at startup.&#x20;
* Project Context & Patterns

    * Root spec: `AGENTS.md` (glossary, coding standards, metadata header, logging/ADR policy).
    * Pattern packs (UI/API/DB agents, tasks) under `agentic-pipeline/patterns/full-stack-app-nextjs-nestjs/…`.&#x20;
* Code Generator (Application)

    * Thin CLI that executes tasks/tools, captures logs, computes diffs, writes `manifest.json`, `changelog.md`, `adr.md`, and updates `turns/index.csv`.

## 3) Filesystem Contract

Container working root: `/workspace`

* Pipeline home: `/workspace/codex-agentic-ai-pipeline` (the pipeline is copied here each turn). Paths referenced by `AGENTS.md` and patterns assume this location.&#x20;
* Target project mount: `/workspace/target` (bind-mounted host repo).
* Turn registry and artifacts (in target project):

    * `/workspace/target/ai/agentic-pipeline/turns/<TurnID>/` with `manifest.json`, `changelog.md`, `adr.md`, `logs/`, `reports/`.
    * `/workspace/target/turns/index.csv` (append-only).&#x20;
* Contexts and patterns (inside pipeline):

    * `/workspace/codex-agentic-ai-pipeline/agentic-pipeline/context/*.md`
    * `/workspace/codex-agentic-ai-pipeline/agentic-pipeline/patterns/**` (UI/API/DB agent docs + tasks).&#x20;


## 9) Turn Lifecycle (what happens when the Code Generator runs)

1. Plan: resolve inputs, allocate next Turn ID, scaffold `/turns/<TurnID>/manifest.json`.
2. Execute: run tools defined by the chosen pattern/tasks (UI/API/DB agents).
3. Record: write `changelog.md`, `adr.md`, complete `manifest.json` with metrics and validations.
4. Commit & Tag: conventional commit including Turn ID and `turn/<ID>` tag; CI enforces presence/validity of artifacts.&#x20;

## 10) Contexts and Pattern Packs included (current version)

* Session context file: `agentic-pipeline/context/codex_session_context.md` (loads selected application implementation pattern into project context).&#x20;
* Project context root: `AGENTS.md` (glossary, coding standards, metadata/ADR/changelog policies).&#x20;
* Pattern: Full-Stack Next.js + NestJS with UI/API/DB agent handbooks and task specs (JSON→SQL, seed data, CRUD endpoints, persistence wiring).&#x20;

## 11) Operational Notes

* The pipeline is copied into the sandbox at the start of each turn, then tools/tasks read from `agentic-pipeline/**` and write into the target project under `ai/agentic-pipeline/turns/...`. This copy-then-execute model is assumed by `AGENTS.md` pathing.&#x20;
* CI should validate `manifest.json` schema, presence of ADR/changelog, and that `diff.patch` matches repo deltas before accepting a turn.&#x20;

