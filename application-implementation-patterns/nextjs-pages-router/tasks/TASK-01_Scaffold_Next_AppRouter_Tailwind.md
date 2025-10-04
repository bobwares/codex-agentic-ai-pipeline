# TASK 01 — Scaffold Next.js (App Router + Tailwind)

## Goal
Create a domain-agnostic Next.js application using the App Router with Tailwind CSS as the default styling system and strict TypeScript configuration. Establish project structure, aliases, tooling, and a minimal feature slice.

## Output (authoritative)
- package.json (scripts: dev, build, start, lint, test)
- tsconfig.json (strict; paths: { "@/*": ["src/*"] })
- next.config.ts (App Router defaults; experimental off unless specified by inputs)
- tailwind.config.ts
- postcss.config.js
- src/app/layout.tsx
- src/app/page.tsx
- src/app/globals.css (Tailwind base + app tokens)
- src/app/error.tsx
- src/app/not-found.tsx
- src/app/loading.tsx
- src/app/api/health/route.ts
- src/components/ui/ProductList.tsx (example presentational component)
- src/services/catalog.ts (example service module; server-only by convention)
- tests/ (Jest + RTL smoke tests)
- .eslintrc.json, .prettier* (tooling)
- .gitignore
- .env.example (from env_template inputs)

## Preconditions
- Node.js 20 LTS installed
- Chosen package manager available (npm | yarn | pnpm)
- Pattern config provided with project metadata and env.env_template

## Steps
1. Initialize Next.js with TypeScript and App Router layout
   - Create project directory and initialize Git if requested.
   - Ensure `src/` source layout; enable `@/*` alias in tsconfig.
2. Add Tailwind
   - Install `tailwindcss postcss autoprefixer` and generate config.
   - Wire `src/app/globals.css` with Tailwind base/components/utilities.
   - Configure `tailwind.config.ts` with `content: ['./src/**/*.{ts,tsx}']`.
3. Establish App Router primitives
   - Create root `layout.tsx` with `<html><body>` and base Tailwind classes.
   - Create `page.tsx` with a minimal landing view proving Tailwind works.
   - Add `error.tsx`, `not-found.tsx`, `loading.tsx` at root scope.
4. Add API health probe
   - `src/app/api/health/route.ts` returns `{ status: 'ok' }` (200).
5. Add example feature slice
   - `src/components/ui/ProductList.tsx` (server component by default).
   - `src/services/catalog.ts` demonstrating server-first fetch and error handling.
6. Tooling and quality
   - Add ESLint config (`eslint-config-next`), Prettier, and Jest + RTL.
   - Populate `.env.example` from `env.env_template` inputs.

## Conformance Checks
- `dev` starts successfully; landing page renders with Tailwind styles.
- `/api/health` returns HTTP 200 with JSON body.
- ESLint and Prettier pass with no errors.
- Tests execute and at least one smoke test passes.
