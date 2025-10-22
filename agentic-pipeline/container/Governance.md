# Governance


## Coding Standards

### Metadata Header

— Every source, test, and IAC file in the target project must begin with Metadata Header comment section.
- exclude pom.xml
- Placement: Top of file, above any import or code statements.
- Version: Increment only when the file contents change.
- Date: UTC timestamp of the most recent change.


#### Metadata Header Template
    ```markdown
      /**
      * App: {{Application Name}}
      * Package: {{package}}
      * File: {{file name}}
      * Version: semantic versioning starting at 0.1.0
      * Turns: append {{turn number}} list when created or updated.
      * Author: {{author}}
      * Date: {{YYYY-MM-DDThh:mm:ssZ}}
      * Exports: {{ exported functions, types, and variables.}}
      * Description: documentate the function of the class or function. Document each
      *              method or function in the file.
      */
    ````

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

{{Turn: {{turn number}}  – {{Date}} - {{Time of execution}}}}


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
<!-- CODEx_TURN_SUMMARY -->

## Statement of Work

<!-- Write a concise description of the work completed during this turn. -->

[Describe the change set at a high level: scope, rationale, notable design decisions.]

## Input Prompt

<!-- Summarize the input prompt, schema name that initiated this turn. -->

[Prompt summary goes here]

## Tasks Executed

<!-- Add a row per task executed during this turn. -->

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

<!-- Exclude anything under /ai. Include the task that created the file. -->

| Path / File | Task Name |
| ----------- | --------- |
|             |           |
|             |           |

## Files Updated

<!-- Exclude anything under /ai. Include the task that updated the file. -->

| Path / File | Task Name |
| ----------- | --------- |
|             |           |
|             |           |

## Checklist

* [ ] Unit tests pass
* [ ] Integration tests pass
* [ ] Linter passes
* [ ] Documentation updated

# Codex Task Link
{{blank}}
```


