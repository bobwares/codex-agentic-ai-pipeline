
# File System Layout

```text
/workspace/
├── agentic-ai-pipeline/          # AGENTIC_PIPELINE_ROOT (read-only)
│   ├── AGENTS.md
│   ├── agentic-pipeline/
│   │   ├── context/
│   │   ├── templates/
│   │   ├── schemas/
│   │   └── tools/
│   └── application-implementation-patterns/
│
└── <target-repo>/                # TARGET_REPO (writable)
    ├── ai/
    │   └── agentic-pipeline/
    │       ├── turns/
    │       └── turns_index.csv
    ├── db/
    ├── services/
    ├── apps/
    └── AGENTS.md → ../agentic-ai-pipeline/AGENTS.md


