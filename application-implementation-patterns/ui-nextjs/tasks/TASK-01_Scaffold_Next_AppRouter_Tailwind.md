# TASK 01 — Scaffold Next.js (App Router + Tailwind)
Task

* Create a domain-agnostic Next.js application using the Application Implementation Pattern: Next.js Scalable (App Router + Tailwind).

Agent requirements

* Generate exactly the files defined in “Generated Files (authoritative)” of the pattern.
* Apply all defaults and constraints from the schema and pattern; do not infer or add fields beyond them.


Completion criteria

* npm run dev starts; root page renders with Tailwind styles.
* GET /api/health returns 200 with { "status": "ok" }.
* npm run lint and npm run typecheck exit 0.
* npm run test (Vitest) and npm run e2e (Playwright) complete without failures.
* The generated file set matches the pattern’s authoritative list exactly.

Implementation notes

* The schema must be read from the local repository (for example: ./schemas/nextjs-scalable-app-router.pattern.v1.json). No network access is required or allowed.
* If validation fails, write nothing and return a structured error report; no autofix.
