# Governance


## Coding Standards

### Metadata Header

— Every source, test, and IAC file in the target project must begin with Metadata Header comment section.
- exclude pom.xml
- Placement: Top of file, above any import or code statements.
- Version: Increment only when the file contents change.
- Date: UTC timestamp of the most recent change.
- use template: {{TEMPLATE_METADATA_HEADER}}


#### Source Versioning Rules

      * Use **semantic versioning** (`MAJOR.MINOR.PATCH`).
      * Start at **0.1.0**; update only when code or configuration changes.
      * Update the version in the source file if it is updated during a turn.

### Git Workflow Conventions

#### 1. Branch Naming

```
<type>/<short-description>-<Task-id?>
```

| Type       | Purpose                                | Example                           |
| ---------- | -------------------------------------- | --------------------------------- |
| `feat`     | New feature                            | `feat/profile-photo-upload-T1234` |
| `fix`      | Bug fix                                | `fix/login-csrf-T5678`            |
| `chore`    | Tooling, build, or dependency updates  | `chore/update-eslint-T0021`       |
| `docs`     | Documentation only                     | `docs/api-error-codes-T0099`      |
| `refactor` | Internal change w/out behaviour change | `refactor/db-repository-T0456`    |
| `test`     | Adding or improving tests              | `test/profile-service-T0789`      |
| `perf`     | Performance improvement                | `perf/query-caching-T0987`        |



#### Commit Messages 

```
AI Coding Agent Change:
<type>(<optional-scope>): <short imperative summary>
<BLANK LINE>
Optional multi-line body (wrap at 72 chars).
<BLANK LINE>
Refs: <Task-id(s)>
```

Example:

```
feature(profile-ui): add in-place address editing

Allows users to update their address directly on the Profile Overview
card without navigating away. Uses optimistic UI and server-side
validation.

```

#### Pull-Request Title

{{Turn {{turn number}}  – {{Date}} - {{Time of execution}}}}


#### Pull-Request Summary Template
- record the following in the changelog.md
    - Record the input prompt.
    - List each task_name executed during a turn.
    - List each tool_name executed during a task.
    - List each agent_name executed during a task.
    - List each path/file_name added during the task.
    - List each path/file_name updated during the task.
    - Use the following template

```markdown
## Turn Summary

<!-- CODEx_TURN_SUMMARY:BEGIN -->

[human-readable summary here]

<!-- CODEx_TURN_SUMMARY:END -->

## Input Prompt

<!-- Summarize the input prompt, schema name that initiated this turn. -->

[Prompt summary goes here]

## Tasks Executed

<!-- Add a row per task executed during this turn. Tools / Agents Executed should include a comma delimited list of tools and agents called.  -->

| Task Name | Tools / Agents Executed |
| --------- | ----------------------- |
|           |                         |
|           |                         |

## Turn Files Added

<!-- List files added under the /ai directory only. One row per file. -->

| Path / File |
| ----------- |
|             |
|             |

## Files Added

<!-- Filter by files that were added during the turn. Exclude anything under /ai. Include the task that created the file. -->

| Path / File | Task Name |
| ----------- | --------- |
|             |           |
|             |           |

## Files Updated

<!-- Filter by files that were updated during the turn. Exclude anything under /ai. Include the task that updated the file. -->

| Path / File | Task Name |
| ----------- | --------- |
|             |           |
|             |           |

## Checklist

* [ ] Unit tests pass
* [ ] Integration tests pass
* [ ] Linter passes
* [ ] Documentation updated

## Codex Task Link
<leave blank>
```


