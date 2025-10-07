# TASK 01 — Initialize Project


## Task

- Create a domain-agnostic Next.js application using the Application Implementation Pattern: Next.js Scalable (App Router + Tailwind).

## Agent requirements

- Generate exactly the files defined in “Generated Files (authoritative)”.
- Apply all defaults and constraints from the application implementation pattern; do not infer or add fields beyond them.
- create initial landing page.

## Completion criteria

- npm run dev starts; root page renders with Tailwind styles.
- GET /api/health returns 200 with { "status": "ok" }.
- npm run lint and npm run typecheck exit 0.
- npm run test (Vitest) and npm run e2e (Playwright) complete without failures.
- The generated file set matches the pattern’s authoritative list exactly.


## Generated Files (authoritative)

- package.json (scripts: dev, build, start, lint, typecheck, test, test:ci, e2e, e2e:ci)
- tsconfig.json (strict, isolatedModules, moduleResolution nodenext, baseUrl ".", paths { "@/*": ["src/*"] })
- next.config.ts (App Router defaults, Server Actions enabled)
- tailwind.config.ts
- postcss.config.js
- src/app/globals.css
- src/app/layout.tsx
- src/app/page.tsx
- src/app/error.tsx
- src/app/not-found.tsx
- src/app/loading.tsx
- src/app/api/health/route.ts
- src/lib/env.ts
- vitest.config.ts
- playwright.config.ts
- env.d.ts
- .eslintrc.json
- .prettierrc
- .gitignore
- .nvmrc
- .npmrc
- .github/workflows/ci.yml
