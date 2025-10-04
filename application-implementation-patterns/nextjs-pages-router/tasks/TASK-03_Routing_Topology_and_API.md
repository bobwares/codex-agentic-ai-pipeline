# TASK 03 — Routing Topology and API (App Router)

## Goal
Materialize the file-based routing structure using segments, route groups, and layouts. Generate API mocks as route handlers under `app/api/*` to support local development.

## Inputs
- `routes[]` from pattern_config
- `api_mocks.enabled` and `api_mocks.endpoints[]`

## Output (authoritative)
- Segment folders and `page.tsx` files per route path
- Optional route groups `(group)` to organize features/domains
- `src/app/api/*/route.ts` handlers for each mock endpoint
- Root and/or nested `layout.tsx` files to compose shared UI

## Steps
1. Build segments:
   - Translate each `path` to its corresponding segment tree (e.g., `/products/[id]` → `src/app/products/[id]/page.tsx`).
   - If the config specifies route groups, reflect with `(group)` folders.
2. Layouts:
   - Ensure root `layout.tsx` exists; add nested layouts where a feature/domain requires its own chrome.
3. API mocks:
   - If `api_mocks.enabled`, generate `src/app/api/<route>/route.ts` per endpoint.
   - Implement HTTP methods returning `status` and `example` body when provided.
   - Keep mocks server-only and side-effect free.
4. Health route:
   - Ensure `src/app/api/health/route.ts` returns `{ status: 'ok' }`.

## Conformance Checks
- All declared paths are routable via file system.
- API mocks respond with the configured status and example payloads.
- No client-only constructs are imported into route handlers.
