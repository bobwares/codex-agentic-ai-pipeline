# Task Pipeline — Next.js App Router + Tailwind (Domain-Agnostic)

## turn 1
1. TASK 01 — Scaffold Next.js (App Router + Tailwind)
2. TASK 02 — Implement Data Fetching by Route
3. TASK 03 — Routing Topology and API
4. TASK 04 — State Strategy and Mutations
5. TASK 05 — Error, Loading, Not Found, and Monitoring

## Inputs Mapping (pattern_config)
- Project: name, description, target_repo_root, package_manager, node_version
- Routing: router=app, source_dir, routes[]
- Services: base_url, headers, timeout_ms, retry
- API mocks: enabled, endpoints[]
- State: kind
- Errors/Monitoring: emit_error_pages, monitoring.provider, monitoring.dsn
- Tooling: eslint, prettier, testing.enabled, testing.coverage_threshold
- Aliases: alias
- Env: env_template, write_env_example

## Success Criteria
- Dev server boots; Tailwind styles apply on the landing page.
- Routes are generated with correct caching (`static` + `revalidate` vs `dynamic`).
- API mocks return configured payloads.
- Mutations use Server Actions and trigger revalidation.
- Error and loading boundaries work at root and segment levels.
