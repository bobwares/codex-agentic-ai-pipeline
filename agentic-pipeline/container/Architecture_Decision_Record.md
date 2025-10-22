### ADR (Architecture Decision Record)

#### Purpose

The `adr.md` file captures concise, high-signal Architecture Decision Records whenever the
AI coding agent (or a human) makes a non-obvious technical or architectural choice.
Storing ADRs keeps the project’s architectural rationale transparent and allows reviewers to
understand why a particular path was taken without trawling through commit history or code
comments.

#### Location

```
project_root/ai/agentic-pipeline/turns/current turn directory/adr.md
```

#### When the Agent Must Create an ADR

| Scenario                                                     | Example                                                                                                                                                                                                                                                                | Required? |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| Summarize Chain of Thought reasoning for the task            | Documenting the decision flow: ① capture requirements for a low-latency, pay-per-request CRUD API → ② compare DynamoDB single-table vs. Aurora Serverless → ③ choose DynamoDB single-table with GSI on email for predictable access patterns and minimal ops overhead. | **Yes**   |
| Selecting one library or pattern over plausible alternatives | Choosing Prisma instead of TypeORM                                                                                                                                                                                                                                     | **Yes**   |
| Introducing a new directory or module layout                 | Splitting `customer` domain into bounded contexts                                                                                                                                                                                                                      | **Yes**   |
| Changing a cross-cutting concern                             | Switching error-handling strategy to functional `Result` types                                                                                                                                                                                                         | **Yes**   |
| Cosmetic or trivial change                                   | Renaming a variable                                                                                                                                                                                                                                                    | **No**    |

#### How ADR Content Is Derived (no private CoT)

The system does not read or expose the model’s hidden chain-of-thought. ADRs are rendered from explicit, verifiable artifacts:

* DecisionFrames: small JSON records emitted at choice points.
* Tool telemetry: wrapped CLI/tool calls with inputs/outputs and status.
* Metrics/diffs: files changed, tests, coverage, lint/typecheck.

Telemetry paths inside the current turn:

* `telemetry/decision_frames/*.json`
* `telemetry/tool_runs/*.json`
* `telemetry/metrics/*.json`
* `telemetry/diffs/*.json`

ADR generation steps:

1. Collect DecisionFrames with ≥2 options or touching architecture-level paths.
2. Correlate with tool_runs, metrics, and diffs.
3. Render the ADR template sections (Context, Options, Decision, Result, Consequences) from these sources.

#### DecisionFrame JSON Schema (companion spec)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://example.com/schemas/decision_frame.schema.json",
  "title": "DecisionFrame",
  "type": "object",
  "required": ["id", "turn_id", "timestamp", "problem", "options", "decision"],
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique identifier for this decision frame."
    },
    "turn_id": {
      "type": "integer",
      "minimum": 1
    },
    "timestamp": {
      "type": "string",
      "format": "date-time"
    },
    "context_ref": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Paths/ids to PRDs, schemas, specs, or prompts considered."
    },
    "problem": {
      "type": "string",
      "minLength": 1,
      "description": "Short statement of the decision to be made."
    },
    "constraints": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Key constraints (latency target, budget, runtime, platform)."
    },
    "options": {
      "type": "array",
      "minItems": 2,
      "items": {
        "type": "object",
        "required": ["name"],
        "properties": {
          "name": { "type": "string", "minLength": 1 },
          "pros": { "type": "array", "items": { "type": "string" } },
          "cons": { "type": "array", "items": { "type": "string" } },
          "evidence": { "type": "array", "items": { "type": "string" } },
          "estimated_cost": { "type": ["number", "null"] },
          "risk_notes": { "type": "array", "items": { "type": "string" } }
        },
        "additionalProperties": false
      }
    },
    "criteria": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["name", "weight"],
        "properties": {
          "name": { "type": "string" },
          "weight": { "type": "number", "minimum": 0 }
        },
        "additionalProperties": false
      }
    },
    "scoring": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["option", "criterion", "score"],
        "properties": {
          "option": { "type": "string" },
          "criterion": { "type": "string" },
          "score": { "type": "number" }
        },
        "additionalProperties": false
      }
    },
    "decision": {
      "type": "object",
      "required": ["chosen_option", "justification"],
      "properties": {
        "chosen_option": { "type": "string" },
        "justification": {
          "type": "string",
          "minLength": 1,
          "description": "2–5 sentence rationale."
        }
      },
      "additionalProperties": false
    },
    "anticipated_consequences": {
      "type": "array",
      "items": { "type": "string" }
    },
    "followups": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Tickets or tests to add."
    },
    "artifacts_touched": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Paths created/changed by this decision."
    }
  },
  "additionalProperties": false
}
```

#### adr-lint: validation rules and config

Rules enforced in CI when an ADR is required:

1. `adr.present`: `adr.md` must exist in the current turn directory if any architecture-level path changed (`src/`, `app/`, `infra/`, `db/`, `api/`, `packages/`, `ops/`).
2. `decision_frame.present`: At least one DecisionFrame JSON exists under `telemetry/decision_frames/`.
3. `decision_frame.valid`: All DecisionFrames validate against `decision_frame.schema.json`.
4. `adr.references.decision_frame`: `adr.md` must include at least one referenced DecisionFrame ID (e.g., `DecisionFrame: df-...`).
5. `adr.sections.complete`: `Context`, `Options Considered`, `Decision`, `Result`, `Consequences` sections are present and non-empty.
6. `adr.result.matches.artifacts`: Files listed in ADR “Result” must be a subset of `manifest.json.artifacts` and/or `changes.added|modified`.
7. `telemetry.evidence.linkage`: If ADR mentions tools or metrics, at least one matching record exists in `telemetry/tool_runs/*` or `telemetry/metrics/*`.
8. `options.min_two`: At least two options were considered in the referenced DecisionFrame.
9. `justification.min_length`: Decision justification length ≥ 140 characters (configurable).
10. `timestamp.coherence`: DecisionFrame.timestamp is within the current turn’s time window.

Example `.adr-lint.yaml`:

```
schema_path: "ai/agentic-pipeline/turns/${TURN_ID}/telemetry/decision_frames/decision_frame.schema.json"
decision_frames_glob: "ai/agentic-pipeline/turns/${TURN_ID}/telemetry/decision_frames/*.json"
adr_path: "ai/agentic-pipeline/turns/${TURN_ID}/adr.md"
manifest_path: "ai/agentic-pipeline/turns/${TURN_ID}/manifest.json"

rules:
  adr.present: error
  decision_frame.present: error
  decision_frame.valid: error
  adr.references.decision_frame: error
  adr.sections.complete: error
  adr.result.matches.artifacts: warn
  telemetry.evidence.linkage: warn
  options.min_two: error
  justification.min_length: warn
  timestamp.coherence: warn

arch_paths:
  - "src/**"
  - "app/**"
  - "infra/**"
  - "db/**"
  - "api/**"
  - "packages/**"
  - "ops/**"
```

#### ADR Template

```markdown
# Architecture Decision Record — {{adr_title}}

**Turn**: {{manifest.turnId}}  
**Timestamp (UTC)**: {{manifest.timestampUtc}}  
**Actor**: initiator={{manifest.actor.initiator}} · agent={{manifest.actor.agent}}  
**Task**: {{manifest.task.name}}  
{{#manifest.task.parameters}}
**Task Parameters**: {{.}}
{{/manifest.task.parameters}}
{{#manifest.task.inputs.length}}
**Inputs**: {{#manifest.task.inputs}}{{.}}{{^last}}, {{/last}}{{/manifest.task.inputs}}
{{/manifest.task.inputs.length}}

{{#decision_frames.length}}
**DecisionFrame IDs**: {{#decision_frames}}{{id}}{{^last}}, {{/last}}{{/decision_frames}}
{{/decision_frames.length}}

---

## Context
{{#primary_decision_frame.problem}}
{{primary_decision_frame.problem}}
{{/primary_decision_frame.problem}}
{{^primary_decision_frame.problem}}
[Describe the problem/decision context. If a DecisionFrame exists, this will auto-fill.]
{{/primary_decision_frame.problem}}

{{#primary_decision_frame.constraints.length}}
**Constraints**: {{#primary_decision_frame.constraints}}{{.}}{{^last}}, {{/last}}{{/primary_decision_frame.constraints}}
{{/primary_decision_frame.constraints.length}}

{{#context_refs.length}}
**Context Refs**: {{#context_refs}}{{.}}{{^last}}, {{/last}}{{/context_refs}}
{{/context_refs.length}}

---

## Options Considered
{{#primary_decision_frame.options.length}}
| Option | Pros | Cons |
|-------|------|------|
{{#primary_decision_frame.options}}
| {{name}} | {{#pros}}{{.}}{{^last}}; {{/last}}{{/pros}} | {{#cons}}{{.}}{{^last}}; {{/last}}{{/cons}} |
{{/primary_decision_frame.options}}
{{/primary_decision_frame.options.length}}
{{^primary_decision_frame.options.length}}
[List at least two plausible options with key trade-offs.]
{{/primary_decision_frame.options.length}}

---

## Decision
{{#primary_decision_frame.decision.chosen_option}}
**Chosen**: {{primary_decision_frame.decision.chosen_option}}  
**Justification**: {{primary_decision_frame.decision.justification}}
{{/primary_decision_frame.decision.chosen_option}}
{{^primary_decision_frame.decision.chosen_option}}
[State the choice made and why it fits the implementation pattern and constraints.]
{{/primary_decision_frame.decision.chosen_option}}

---

## Result
{{#artifacts_created.length}}
**Artifacts**: {{#artifacts_created}}{{.}}{{^last}}, {{/last}}{{/artifacts_created}}
{{/artifacts_created.length}}

{{#manifest.artifacts}}
**Recorded Artifacts (from manifest.json)**:
- changelog: {{changelog}}
- adr: {{adr}}
- diff: {{diff}}
{{#logs.length}}- logs: {{#logs}}{{.}}{{^last}}, {{/last}}{{/logs}}{{/logs.length}}
{{#reports.length}}- reports: {{#reports}}{{.}}{{^last}}, {{/last}}{{/reports}}{{/reports.length}}
{{/manifest.artifacts}}

{{#manifest.changes}}
**Files Changed (from manifest.json)**:
{{#added.length}}- Added ({{added.length}}): {{#added}}{{.}}{{^last}}, {{/last}}{{/added}}{{/added.length}}
{{#modified.length}}- Modified ({{modified.length}}): {{#modified}}{{.}}{{^last}}, {{/last}}{{/modified}}{{/modified.length}}
{{#deleted.length}}- Deleted ({{deleted.length}}): {{#deleted}}{{.}}{{^last}}, {{/last}}{{/deleted}}{{/deleted.length}}
{{/manifest.changes}}

{{#primary_decision_frame.artifacts_touched.length}}
**Artifacts Touched (from DecisionFrame)**: {{#primary_decision_frame.artifacts_touched}}{{.}}{{^last}}, {{/last}}{{/primary_decision_frame.artifacts_touched}}
{{/primary_decision_frame.artifacts_touched.length}}

---

## Consequences
{{#primary_decision_frame.anticipated_consequences.length}}
{{#primary_decision_frame.anticipated_consequences}}- {{.}}
{{/primary_decision_frame.anticipated_consequences}}
{{/primary_decision_frame.anticipated_consequences.length}}
{{^primary_decision_frame.anticipated_consequences.length}}
[List trade-offs, risks, operational impacts, and follow-ups.]
{{/primary_decision_frame.anticipated_consequences.length}}

{{#followups.length}}
**Follow-ups / Tickets**:
{{#followups}}- {{.}}
{{/followups}}
{{/followups.length}}

---

## Metrics (from manifest.json)
{{#manifest.metrics}}
- filesChanged: {{filesChanged}}
- linesAdded: {{linesAdded}} · linesDeleted: {{linesDeleted}}
- testsPassed: {{testsPassed}} · testsFailed: {{testsFailed}}
- coverageDeltaPct: {{coverageDeltaPct}}
{{/manifest.metrics}}

{{#validation_summary}}
## Validation
- adrPresent: {{adrPresent}} · changelogPresent: {{changelogPresent}}
- lintStatus: {{lintStatus}} · testsStatus: {{testsStatus}}
{{/validation_summary}}

---

## Evidence
{{#telemetry.decision_frames.length}}
- DecisionFrames: {{#telemetry.decision_frames}}{{.}}{{^last}}, {{/last}}{{/telemetry.decision_frames}}
{{/telemetry.decision_frames.length}}
{{#telemetry.tool_runs.length}}
- Tool Runs: {{#telemetry.tool_runs}}{{.}}{{^last}}, {{/last}}{{/telemetry.tool_runs}}
{{/telemetry.tool_runs.length}}
{{#telemetry.metrics.length}}
- Metrics: {{#telemetry.metrics}}{{.}}{{^last}}, {{/last}}{{/telemetry.metrics}}
{{/telemetry.metrics.length}}
{{#telemetry.diffs.length}}
- Diffs: {{#telemetry.diffs}}{{.}}{{^last}}, {{/last}}{{/telemetry.diffs}}
{{/telemetry.diffs.length}}

<!--
Rendering notes:
- primary_decision_frame := selected DecisionFrame for this ADR (e.g., most impactful).
- decision_frames := all DecisionFrames in this turn.
- artifacts_created := concrete artifacts produced during the decision’s execution.
- telemetry.* := file lists from ai/agentic-pipeline/turns/<turn_id>/telemetry/**.
- validation_summary binds manifest.validation.* if available.
- Use your templating engine’s iteration/conditional syntax to resolve {{#...}} blocks.
-->
```

