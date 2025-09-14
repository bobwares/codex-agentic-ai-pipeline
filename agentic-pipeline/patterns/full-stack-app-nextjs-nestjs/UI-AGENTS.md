# Front-End AI Coding Agent (Codex) Context

## 1. Purpose

Provide Codex with all information needed to generate, modify, and validate the front-end application code reliably and consistently. This document defines the project context, conventions, constraints, and prompt templates that the AI Coding Agent will use.

## 2. Application Overview

This is a Next.js + TypeScript UI that connects to a backend API at `project_root/api`. Its responsibilities include:

* Rendering pages and components under `src/`
* Fetching data from REST endpoints (e.g. `/profile`, `/customers`)
* Managing client-side state and user interactions
* Styling via Tailwind CSS

## 3. Technology Stack

**Runtime**

* Node.js (v20 or later)

**Language**

* TypeScript (v5.x or later)

**Framework**

* Next.js (latest stable)

**Styling**

* Tailwind CSS (latest stable)

**Testing**

* Jest + React Testing Library

Refer to `project_root/ui/package.json` for exact dependency versions.

## 4. Coding Style & Conventions

1. **Directory Layout**

   * All production code resides under `src/`.
   * Tests mirror the source structure under `src/` (unit tests) or in `__tests__/` (integration/e2e).

2. **Metadata Headers**
   Each source file must begin with a metadata header that specifies the application name, package, file path, semantic version, author, date, and a brief description.

   *Definition of metadata header section:*

   ```markdown
   # App: {{Application Name}}
   # Package: {{package}}
   # File: {{file name}}
   # Version: sematic versioning starting at 0.1.0
   # Author: {{author}}
   # Date: {Timestamp when the change was made}
   # Description:  level 5 documentation of the class or function.  Document each method or function in the file.  
   #
   ```

3. **Test-Driven Development (TDD)**

   * Write unit tests before implementation.
   * Name test files `<module>.test.ts`.
   * Place unit tests in the same directory as the source code being tested
   * Maintain a minimum 80% coverage.
   * npm run test

4. **Modern Language Features**

   * Use async/await, optional chaining, nullish coalescing, etc.
   * Avoid deprecated or legacy APIs.
   * Update dependencies regularly to leverage new features and security fixes.

5. **Documentation**

   * Maintain `project_root/ui/README.md` with:
      * Overview and purpose
      * Setup and build instructions
      * Usage examples and API reference
      * Links to design artifacts

## 5. Architectural Constraints

1. **Multi-Environment Support**

   * Environments: `local`, `development`, `staging`, `production`
   * Active environment specified via `APP_ENV` or `NODE_ENV`.

2. **Externalized & Validated Configuration**

   * All settings (endpoints, credentials, flags) provided via environment variables.
   * Validate at startup using a schema (e.g. JSON Schema, Joi, or Zod). Fail fast on missing or invalid values.

3. **Secret Management**

   * Fetch sensitive data (API keys, DB passwords) from a secure vault or secrets manager at runtime.
   * Do not commit secrets to source control.

4. **Logging & Monitoring**

   * Configurable log levels (`DEBUG`, `INFO`, `WARN`, `ERROR`) via env var.
   * Emit structured JSON logs.
   * Expose `/health` and `/ready` endpoints and a `/metrics` endpoint for Prometheus/OpenTelemetry.

5. **Twelve-Factor Compliance**

   * Strict separation of config from code.
   * Build once, deploy the same artifact across all environments.

6. **CI/CD & Feature Flags**

   * Use the same build artifact for every environment; inject environment-specific configuration at deployment time.
   * Support feature toggles via environment variables or a feature-flag service.

7. **Secure Defaults & Reload**

   * Default to the most restrictive settings (e.g. SSL enforcement, least-privilege credentials).
   * Optionally support hot reload of configuration (e.g. via SIGHUP), with documentation on which changes require a process restart.

## 6. Agent Prompt Template

Use this structure when creating prompts for Codex:

### Context

Provide a brief summary of the module or component, list the tech stack, current environment, and relevant API endpoints:

```
<Brief summary>
Tech: Next.js, TypeScript, Tailwind CSS
Env: { APP_ENV = "<env>" }
API: <endpoints>
```

### Task

State a clear instruction, for example:

```
Generate a `ProfileOverview.tsx` React component under `src/components/ProfileOverview/`.
```

### Constraints

List any specific requirements:

```
- Prepend the metadata header as specified
- Include TypeScript interfaces
- Write accompanying unit tests in `ProfileOverview.test.tsx`
```

### Output Format

Define how Codex should structure its response:

```
- Provide complete file content blocks
- No explanatory text outside code fences
```

## 7. Sample Prompt

```
### Context
Profile overview module displays user info fetched from `/api/profile`.
Tech: Next.js, TypeScript, Tailwind CSS
Env: { APP_ENV = "development" }

### Task
Implement `ProfileOverview.tsx` under `src/components/ProfileOverview/`.
- Fetch `/api/profile` on mount.
- Show loading spinner, error message, or data card.
- Provide `onEdit()` callback.

### Constraints
- Prepend the required metadata header.
- Use Tailwind utility classes.
- Write tests in `ProfileOverview.test.tsx` with Jest + RTL.

### Output Format
- Two code fences: one for the component, one for the test.
```


End of Document

