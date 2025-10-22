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

**Rules**

1. One branch per Task or atomic change.
2. **Never** commit directly to `main` or `develop`.
3. Re-base on the target branch before opening a pull request.

---

#### 2. Commit Messages (Conventional Commits)

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

Refs: T1234
```
---

#### 3. Pull-Request Summary Template

Copy this template into every PR description and fill in each placeholder.

```markdown

## Statement of Work

    {{ generate a description of the work complete during the task. }}

--

## Input Prompt

    {{ input prompt}}

--

## Tasks Executed
    - {{task name executed during a turn}}
     - {{tools/agents that are execute during a task.}}
    
    ## Turn Tracking Files Added
    List: all path/file_name added under the /ai directory
    
     ## Files Added
    Table: all path/file_name added. exclude path/file_name added under the /ai directory :: col1 path/file_name col2 task_name that created the file.
   
    
    ## Files Updated
    Table: all path/file_name added. exclude path/file_name added under the /ai directory :: col1 path/file_name col2 task_name that created the file.


# Checklist
- [ ] Unit tests pass 
- [ ] Integration tests pass
- [ ] Linter passes
- [ ] Documentation updated


# Codex Task Link
{{blank}}
```

