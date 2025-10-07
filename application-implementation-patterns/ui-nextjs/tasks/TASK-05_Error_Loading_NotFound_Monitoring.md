# TASK 05 — Error, Loading, Not Found, and Monitoring

## Goal
Provide resilient UX with segment-scoped boundaries and optional monitoring. Ensure clear fallbacks, recoverability, and observability.

## Inputs
- `errors.emit_error_pages` (boolean)
- `errors.monitoring.provider` (sentry|none), `errors.monitoring.dsn` if sentry

## Output (authoritative)
- `error.tsx`, `not-found.tsx`, `loading.tsx` at root and/or segments as needed
- Optional `global-error.tsx` at the project root
- Monitoring initialization (client and server stubs) when requested

## Steps
1. Emit boundaries:
   - At minimum, create root-level `error.tsx`, `not-found.tsx`, and `loading.tsx`.
   - For heavy segments, provide per-segment `loading.tsx` with Suspense-friendly fallbacks.
2. Monitoring (optional):
   - If provider = sentry, initialize SDK for both server and client.
   - Configure source maps in CI and suppress noisy errors with sensible filters.
3. Logging:
   - Ensure route handlers and services log failures at the boundary, not in presentational components.

## Conformance Checks
- Uncaught render errors are captured and surfaced by `error.tsx` with a retry affordance.
- Slow segments show `loading.tsx` immediately (no blank screens).
- Monitoring, when enabled, receives events from both server and client contexts.
