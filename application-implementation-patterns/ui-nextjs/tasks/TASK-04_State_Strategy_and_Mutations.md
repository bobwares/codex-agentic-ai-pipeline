# TASK 04 — State Strategy and Mutations

## Goal
Minimize client state while enabling necessary interactivity. Prefer Server Actions for mutations. Escalate to Redux Toolkit or Zustand only when cross-cutting client state is required.

## Inputs
- `state.kind` (context | redux | zustand)
- Optional mutation requirements from the domain/features

## Output (authoritative)
- For `context`: lightweight provider(s) used only in client components that need them
- For `redux` or `zustand`: store setup, typed hooks, and provider wiring in the minimal client boundary
- Server Actions for create/update/delete flows, with cache invalidation via `revalidatePath` or `revalidateTag`
- Route handlers (`app/api/*`) where multi-client or external access is required

## Steps
1. Default server-first approach:
   - Implement mutations as Server Actions colocated with server components or in dedicated action files.
   - After mutation, call `revalidateTag('...')` or `revalidatePath('/route')` as appropriate.
2. Client state minimalism:
   - Avoid lifting state globally unless justified; prefer local state in client components.
3. Optional global state:
   - `redux`: configure store, slices, and `<Provider>` boundary in a small client wrapper.
   - `zustand`: create store with typed selectors; import only in client components.
4. Forms and actions:
   - Use `<form action={serverAction}>` for progressive enhancement.
   - Provide optimistic UI when warranted; reconcile on server response.

## Conformance Checks
- No server-only modules imported into client components.
- Mutations trigger appropriate cache/path revalidation.
- Global state used only when there is proven cross-page or collaborative need.
