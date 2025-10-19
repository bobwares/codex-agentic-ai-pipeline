# Unity Agentic AI Pipeline — Application Implementation Pattern

Meta

* Pattern name: Unity Agentic AI Pipeline
* Pattern version: 0.1.0
* Status: Draft
* Owner: bobwares
* Date: 2025-10-17
* Summary: Prescriptive pattern for building a Unity game with C# that integrates an agentic pipeline to plan, generate, validate, and deliver content, code, and build artifacts. Emphasizes spec-driven development, Addressables-based remote content, deterministic CI/CD, and reproducible turn logs.

## 1. Objectives and Scope

### Goals

* Encode Unity project layout, agent roles, and artifacts so agents can plan → generate → validate in reproducible turns.
* Minimize initial app size using Addressables and remote delivery (UGS CCD or AWS S3/CloudFront) with lazy loading.
* Make gameplay, content packs, and configuration spec-driven via JSON Schema and ScriptableObjects.
* Codify CI tasks (lint, compile, tests, content pack build, catalog publish, build export).

### Non-Goals

* General Unity tutorials.
* Custom MMO/Netcode stack.

### Target Platforms

* iOS 17+, Android 10+, macOS, Windows.

### Rendering

* URP recommended for mobile targets.

## 2. Tech Stack

### Runtime

* Unity 2022/2023 LTS
* C# 10/11 (per Unity LTS profile)

### Unity Packages

* Addressables 1.x
* UGS (optional): Cloud Content Delivery (CCD), Remote Config, Analytics
* Input System
* TextMeshPro
* Unity Test Framework (EditMode/PlayMode)

### Build and Tooling

* Unity Hub (editor management)
* CI runners: GameCI or Unity Official CI images
* Node.js 20 (CLI glue scripts)
* Python 3.11 (optional data tooling)

### Agentic Pipeline

* Agents, prompts, and turns stored under ai/
* Provider-agnostic LLM access via scriptable CLI

### Content Delivery

* Primary: UGS CCD
* Alternate: AWS S3 + CloudFront

### Serialization and Schemas

* JSON Schema for domain/content specs
* ScriptableObjects for runtime configuration

### Observability

* Structured logs to ai/agentic-pipeline/turns/* and Unity Application.persistentDataPath
* Optional: OpenTelemetry exporter

## 3. Repository and Directory Structure

```
/
├─ Assets/
│  ├─ Game/
│  │  ├─ Scripts/
│  │  │  ├─ Runtime/
│  │  │  ├─ Editor/
│  │  │  ├─ Generated/                 # Agent-generated (do not hand-edit)
│  │  │  ├─ Integration/               # Services: content, telemetry, config
│  │  │  └─ Gameplay/                  # Systems, components
│  │  ├─ Art/
│  │  ├─ Audio/
│  │  ├─ UI/
│  │  └─ Config/
│  │     ├─ ScriptableObjects/
│  │     └─ Schemas/                   # JSON schemas
│  ├─ Addressables/
│  │  ├─ Groups/
│  │  └─ Profiles/
│  └─ Tests/
│     ├─ EditMode/
│     └─ PlayMode/
├─ Packages/
├─ ProjectSettings/
├─ UserSettings/                        # not committed
├─ Build/
│  ├─ Artifacts/                        # zipped players
│  └─ Addressables/                     # bundles per platform
├─ Content/
│  ├─ Sources/                          # raw content (CSV/JSON/media pointers)
│  └─ Packs/
│     └─ pack-<name>/
│        ├─ manifest.json
│        ├─ data/*.json
│        └─ media/*                     # optional pointers
├─ scripts/
│  ├─ agent-cli.mjs
│  ├─ unity-ci.sh
│  ├─ addressables.mjs
│  └─ content-validate.mjs
├─ docs/
│  ├─ architecture.md
│  ├─ content-pipeline.md
│  └─ addressables.md
├─ .env.example                          # plain ${VAR} usage only
├─ .gitignore
└─ unity-ci.yml
```

## 4. Configuration and Environment

### Environment Variables (examples)

* UNITY_VERSION
* UNITY_LICENSE
* CCD_PROJECT_ID, CCD_BUCKET_ID, CCD_API_KEY
* AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, S3_BUCKET
* REMOTE_BASE_URL, REMOTE_CATALOG_URL
* AGENT_PROVIDER, AGENT_MODEL, AGENT_API_KEY

### ScriptableObjects

* ContentDeliveryConfig: provider=CCD|S3, baseUrl, catalogUrl, platform
* GameplayTuning: difficulty curves, spawn rates
* FeatureToggles: enableRemoteConfig, enableTelemetry

### Addressables Profiles

* Dev: local hosting
* Staging: remote URLs
* Prod: remote URLs + cache constraints

## 5. Agent Roles

* Planner Agent: consume schemas/intents, emit task plan and acceptance criteria.
* Senior Coder Agent: scaffolds integration code, ScriptableObjects, addressable labeling.
* Junior Coder Agent: fill methods, add tests, small refactors within constraints.
* Reviewer Agent: compilation checks, test gating, addressables dry-run.
* CI Agent: batchmode Unity, tests, bundle build, upload, player export.
* Content Curator Agent: validate manifests, platform splits, memory budgets.

## 6. Schemas (Selected)

### 6.1 Content Pack Manifest (JSON Schema)

* packId: string
* version: semver
* platformTargets: [iOS|Android|Standalone]
* entries: array of { key, type, addressableLabel, dependencies[] }
* memoryBudgetMB: number
* loadHints: [startup|lazy|onDemand]
* file: Content/Packs/pack-<name>/manifest.json

### 6.2 Remote Content Policy (JSON)

* startupBundles: keys to preload at boot
* warmupLists: scene-specific preloads
* retry/backoff policy, cache eviction strategy

## 7. Code Generation Targets

* Assets/Game/Scripts/Integration/Addressables/RemoteContentLoader.cs

    * Initialize Addressables, set remote catalog URL, LoadAsync<T>(key), Preload(keys)
* Assets/Game/Scripts/Integration/Config/RemoteConfigClient.cs
* Assets/Game/Scripts/Generated/*

    * DTOs from schemas, factories/registries

### RemoteContentLoader.cs (excerpt)

```csharp
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

namespace Game.Integration.Addressables
{
    public static class RemoteContentLoader
    {
        public static async Task InitializeAsync(string remoteCatalogUrl)
        {
            AddressablesRuntimeProperties.SetPropertyValue("REMOTE_CATALOG_URL", remoteCatalogUrl);
            await Addressables.InitializeAsync().Task;
        }

        public static AsyncOperationHandle<T> LoadAsync<T>(string key)
        {
            return Addressables.LoadAssetAsync<T>(key);
        }

        public static async Task<IList<AsyncOperationHandle>> PreloadAsync(IEnumerable<string> keys)
        {
            var handles = new List<AsyncOperationHandle>();
            foreach (var key in keys)
            {
                var h = Addressables.LoadAssetAsync<Object>(key);
                handles.Add(h);
                await h.Task;
            }
            return handles;
        }
    }
}
```

## 8. Addressables Strategy

* Labels: pack:<name>, platform:<target>, hint:<startup|lazy|onDemand>
* Group split:

    * core: bootstrap assets (UI, fonts, bootstrap prefabs)
    * levels/light: first-session scenes
    * levels/heavy: deferred scenes
    * cosmetics: optional skins
* Catalogs:

    * Versioned per release
    * Client checks for updates at startup with backoff
* Profiles bind remote URLs via variables

## 9. Testing Strategy

* EditMode: serialization tests for manifests and ScriptableObjects; loader unit tests.
* PlayMode (headless): preload → load → instantiate flow; memory budget assertions by pack.
* Content tests: schema validation gate; dependency cycle checks.

## 10. CI/CD Workflow (unity-ci.yml sketch)

Stages

* lint: analyzers, schema validation
* compile: Unity batchmode
* test-edit: EditMode
* test-play: PlayMode headless
* addr-build: Addressables build per platform
* upload-content: push to CCD or S3
* build-player: export iOS/Android/Desktop
* release: release manifest with checksums

Artifacts

* Build/Artifacts/*.zip
* Build/Addressables/<platform>/*
* ai/agentic-pipeline/turns/*/artifacts/*
* release-manifest.json

## 11. Logging and Manifests

* Turn manifest: inputs, steps, outputs, checksums, exit status
* Task logs: stdout/stderr for Unity invocations
* Release manifest: build number, catalog URL, bundles, checksums
* Optional telemetry: build/test durations, failure reasons

## 12. Security

* Secrets only via environment; never committed
* Verify bundle checksums prior to upload
* Allowlist pack labels and platforms
* Optional code signing for catalogs/bundles

## 13. Acceptance Criteria

* Fresh clone can run plan → code → validate → deliver in CI after env is set and CI license present.
* Addressables build completes for iOS and Android; catalogs/bundles fetchable by runtime loader.
* Headless PlayMode test loads a startup bundle and instantiates a prefab by key.
* All content pack manifests pass schema validation and dependency checks.

## 14. Migration

* Introduce /Content packs and labels incrementally.
* Extract core assets into pack-core with hint=startup.

---

# task-pipeline.md

This document defines the execution pipeline and the task inventory. Task specifications live in separate documents under ai/tasks/* and are referenced here by path. Each task file contains: id, role, title, rationale, inputs, outputs, acceptance, failure_modes, and run_instructions.

## 1. Pipeline Stages

1. Plan
2. Code
3. Content
4. Validate
5. Deliver

A typical run materializes as a Turn in ai/agentic-pipeline/turns/<date>_turn-XXXX with a turn manifest and per-task logs.

## 2. Required Tasks by Stage

### 2.1 Plan

* ai/tasks/plan/task-generate-plan.md

    * Role: Planner
    * Purpose: Produce turn plan from product intent and schemas; define acceptance criteria and ordering.
* ai/tasks/plan/task-derive-addressables-splits.md

    * Role: Planner
    * Purpose: Propose group/label splits and load hints based on content size and first-session UX.
* ai/tasks/plan/task-create-turn-manifest.md

    * Role: Planner
    * Purpose: Emit turn manifest with checksums and environment capture.

### 2.2 Code

* ai/tasks/code/task-init-remote-content-loader.md

    * Role: Senior Coder
    * Purpose: Implement RemoteContentLoader.cs and tests.
* ai/tasks/code/task-config-scriptableobjects.md

    * Role: Senior Coder
    * Purpose: Define ContentDeliveryConfig, FeatureToggles, GameplayTuning SOs.
* ai/tasks/code/task-remote-config-client.md

    * Role: Junior Coder
    * Purpose: Implement RemoteConfig client wrapper and unit tests.
* ai/tasks/code/task-generated-dtos-from-schemas.md

    * Role: Junior Coder
    * Purpose: Generate DTOs and registries from JSON Schemas into Assets/Game/Scripts/Generated.

### 2.3 Content

* ai/tasks/content/task-content-pack-manifests.md

    * Role: Content Curator
    * Purpose: Author Content/Packs/*/manifest.json per schema, set labels and load hints.
* ai/tasks/content/task-addressables-grouping.md

    * Role: Senior Coder
    * Purpose: Create Addressables Groups and Profiles; bind remote URLs via variables.
* ai/tasks/content/task-build-content-packs.md

    * Role: CI Agent
    * Purpose: Build Addressables bundles per platform.

### 2.4 Validate

* ai/tasks/validate/task-schema-validate-content.md

    * Role: Reviewer
    * Purpose: Validate manifests against JSON Schema; fail on violations.
* ai/tasks/validate/task-editmode-tests.md

    * Role: Reviewer
    * Purpose: Run EditMode tests; capture coverage.
* ai/tasks/validate/task-playmode-headless-smoke.md

    * Role: Reviewer
    * Purpose: Run headless smoke scene that preloads startup bundles and instantiates a prefab by key.
* ai/tasks/validate/task-addressables-dry-run.md

    * Role: Reviewer
    * Purpose: Addressables build dry-run; dependency report and cycle detection.

### 2.5 Deliver

* ai/tasks/deliver/task-upload-catalogs-and-bundles.md

    * Role: CI Agent
    * Purpose: Upload to CCD or S3; emit URLs and checksums.
* ai/tasks/deliver/task-build-players.md

    * Role: CI Agent
    * Purpose: Export iOS/Android/Desktop players.
* ai/tasks/deliver/task-release-manifest.md

    * Role: CI Agent
    * Purpose: Publish release-manifest.json with catalog URL, bundle list, and SHA256s.

## 3. Orchestration Rules

* Stage barriers: downstream stages cannot begin until all tasks in prior stage meet acceptance.
* Determinism: all generators must write to Assets/Game/Scripts/Generated or designated output folders; outputs must be idempotent given identical inputs.
* Environment capture: each task records AGENT_PROVIDER, AGENT_MODEL, UNITY_VERSION, platform, and profile in its log header.
* Rollback: if any Deliver task fails, pipeline rolls back uploaded content by invalidating the release manifest and marking the turn as failed.

## 4. Inputs and Artifacts

### Inputs

* Product intents and epics in docs/
* JSON Schemas in Assets/Game/Config/Schemas/
* Addressables Profiles in Assets/Addressables/Profiles/

### Artifacts

* Build/Addressables/<platform>/*
* Build/Artifacts/*.zip
* ai/agentic-pipeline/turns/*/artifacts/*
* release-manifest.json

## 5. Acceptance Gates (Pipeline Level)

* Plan: turn manifest exists with ordered tasks and explicit acceptance per task.
* Code: project compiles; generated code present; loaders and config compile.
* Content: at least one pack with hint=startup; groups and labels match plan.
* Validate: EditMode and PlayMode smoke pass; schema validation clean; addr dry-run clean.
* Deliver: catalogs and bundles uploaded and verified; release manifest published with checksums; sample client run resolves remote catalog and loads a startup key.

## 6. Failure Modes and Handling

* Schema drift: fail validate tasks; block Deliver; require schema regeneration task re-run.
* Catalog mismatch: block Deliver; regenerate catalog and repeat Validate.
* Memory budget breach: PlayMode smoke fails; Planner must re-split packs; rerun Content and Validate.
* Upload partials: atomic publish rule—release-manifest.json is written only after uploads verify.

## 7. How to Run Locally

1. Set environment variables from .env.example.
2. Install Unity LTS, open project once to generate Library.
3. Run: `node scripts/agent-cli.mjs plan` to emit the turn manifest.
4. Execute stage tasks in order using `node scripts/agent-cli.mjs run --task <path>`.
5. For content: `node scripts/addressables.mjs build --platform ios --profile Staging`.
6. For validation: run EditMode/PlayMode test runners or via CI steps.
7. For delivery: `node scripts/addressables.mjs upload --provider CCD --profile Staging`.

## 8. Versioning

* Pattern version increments on any structural change to directories, stage gates, or acceptance criteria.
* Task spec files carry their own semantic versions and changelogs.
