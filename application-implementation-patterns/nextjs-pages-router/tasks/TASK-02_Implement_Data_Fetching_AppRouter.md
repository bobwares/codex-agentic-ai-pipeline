# TASK 02 — Implement Data Fetching by Route (App Router)

## Goal
For each declared route, generate a server-first container in `app/*` that fetches data via `src/services/*` (or inline when specified), sets the correct caching mode, and (when static) configures ISR revalidation and optional cache tags.

## Inputs
- `routes[]` from pattern_config with fields:
  - path, render (static | dynamic), revalidate (if static)
  - params (none | generate-static | dynamic-only)
  - data_source (service | inline), service_name (if service)
  - cache_tags (optional), seo (optional), generate_test (boolean)
- `services` defaults (base_url, headers, timeout, retry)

## Output (authoritative)
- One server component per route under `src/app/.../page.tsx`
- `generateStaticParams` when `params = generate-static`
- Revalidation constants when `render = static`
- Optional cache tags applied via `fetch(..., { next: { tags } })`
- Tests for each route when `generate_test = true`

## Steps
1. For each route entry:
   - Create `src/app/<path>/page.tsx` as a Server Component.
   - If `render = static`, set `export const revalidate = <seconds>`.
   - If `render = dynamic`, set `export const dynamic = 'force-dynamic'` (or `export const fetchCache = 'force-no-store'` when more appropriate).
2. Params handling:
   - If `params = generate-static`, emit `export async function generateStaticParams()` and call the associated service to enumerate IDs.
   - If `params = dynamic-only`, no static params emission.
3. Data source wiring:
   - If `data_source = service`, call `src/services/<module>.<fn>` with `{ next: { revalidate, tags } }` as applicable.
   - If `data_source = inline`, embed minimal `fetch`/mock logic within the page file (server-side only).
4. SEO:
   - When `seo` present, emit `export const metadata = { title, description }` in the segment file or layout as needed.
5. Tests:
   - Create a minimal component/route smoke test verifying render and (for static routes) presence of expected content.

## Conformance Checks
- No client-side data fetching in presentational components.
- All service imports are used from server boundaries only.
- Static routes include `revalidate`; dynamic routes disable caching appropriately.
- When `cache_tags` are provided, route uses `next: { tags }`.
