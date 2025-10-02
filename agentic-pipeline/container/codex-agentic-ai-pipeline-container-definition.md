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

## 4) Process Model

Primary process: `codex-turn` (CLI)

* `codex-turn init --task <name> --inputs <paths>` → allocates Turn ID, scaffolds turn dir.
* `codex-turn run --plan <file://…>` → executes tools/tasks with logging.
* `codex-turn record --from-git --collect-logs` → diff + manifest + metrics.
* `codex-turn finalize --commit --tag --open-pr` → validations, commit/tag.&#x20;

## 5) Networking and Interfaces

* CLI first. Optionally expose an internal HTTP control port (e.g., `8080`) for health/metrics if you wrap the CLI in a daemon, but it’s not required by the current spec. The authoritative contract is the filesystem + CLI described above.&#x20;

## 6) Environment Variables (no fallbacks)

| Variable             | Purpose                                                                      |
| -------------------- | ---------------------------------------------------------------------------- |
| `CODEX_ACTOR`        | Logical initiator (e.g., bobwares) for manifest/metadata.                    |
| `CODEX_TASK`         | Default task if not provided on CLI.                                         |
| `CODEX_PATTERN_PATH` | Pattern root to load (defaults to `agentic-pipeline/patterns/...` if empty). |
| `TARGET_REPO_DIR`    | Absolute path mounted at `/workspace/target`.                                |

These influence manifest fields and path resolution; the turn spec and pathing come from the repo docs.&#x20;

## 7) Minimal Dockerfile

```dockerfile
# Container: Codex Agentic AI Pipeline
FROM node:20-alpine

# System deps often needed by tools (git/diff/patch, bash)
RUN apk add --no-cache git bash diffutils

WORKDIR /workspace

# Pipeline code (baked into the image)
# Copy your pipeline repo to the image at build time:
#   docker build -t codex/pipeline:0.1.0 .
COPY . /workspace/codex-agentic-ai-pipeline

# Add CLI to PATH (assuming bin script)
ENV PATH="/workspace/codex-agentic-ai-pipeline/bin:${PATH}"

# Default working dirs; the target project is a volume mount at runtime
VOLUME ["/workspace/target"]

# Entrypoint exposes the CLI; override CMD to run specific turn actions
ENTRYPOINT ["codex-turn"]
CMD ["--help"]
```

## 8) Minimal docker-compose.yaml

```yaml
services:
  codex:
    image: codex/pipeline:${CODEX_IMAGE_TAG}
    container_name: codex-agentic
    working_dir: /workspace
    environment:
      CODEX_ACTOR: ${CODEX_ACTOR}
      CODEX_TASK: ${CODEX_TASK}
      CODEX_PATTERN_PATH: ${CODEX_PATTERN_PATH}
      TARGET_REPO_DIR: /workspace/target
    volumes:
      - ${TARGET_REPO_DIR}:/workspace/target
    # Uncomment to run a turn end-to-end on start:
    # command: ["init", "--task", "${CODEX_TASK}"]
```

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

If you want, I can add a `bin/codex-turn` scaffold and a Makefile to wrap common commands next.&#x20;
