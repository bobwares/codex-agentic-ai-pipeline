# Application Implementation Pattern: Next.js Scalable (App Router + Tailwind)

## Purpose

Codify five key design patterns—Container/Presentational, Data Fetching, Routing, State Management, and Error Handling—into a repeatable Next.js App Router template with clear tasks, directory conventions, and conformance checks. The pattern is domain-agnostic and can host any business domain via feature or domain modules.

## Applicability

Use when you want a scalable, maintainable web UI using the App Router (`app/`) with server components by default, route handlers in `app/api`, streaming/Suspense, and granular caching/revalidation. Works for marketing sites, dashboards, CRUD, and data apps. Tailwind provides consistent utility-first styling.

---

## Tech Stack

* Runtime: Node.js 20 LTS
* Framework: Next.js (App Router)
* Language: TypeScript
* UI: React (Server Components by default; Client Components where interactivity is required)
* Styling: Tailwind CSS (+ PostCSS, Autoprefixer)
* Lint/Test: eslint-config-next, React Testing Library + Jest
* Optional State: Context API (default), Redux Toolkit or Zustand (opt-in)

---

## High-Level Design Rules (enforceable)

1. **Container/Presentational split across server/client boundaries**

  * Containers are Server Components that do data fetching and compose UI.
  * Presentational components are mostly Server Components; mark as Client (`"use client"`) only when needed (event handlers, browser APIs).
2. **Server-first data fetching**

  * Use service functions in `src/services/*` (server-only) or `fetch` with `cache`/`next.revalidate`/tags.
  * Prefer static rendering with revalidation for read-heavy routes; use dynamic rendering only when necessary.
3. **App Router discipline**

  * File-based routing under `src/app/*`, segment layouts, route groups, dynamic segments, and `app/api/*` route handlers.
4. **State scope minimization**

  * Keep client state minimal; push data/logic server-side. Escalate to Redux/Zustand only for complex cross-page or collaborative state.
  * Use Server Actions for mutations when possible.
5. **Robust error and UX boundaries**

  * Segment-level `error.tsx`, `not-found.tsx`, `loading.tsx`. Stream with Suspense for large data. Add monitoring hooks.

---

## Directory Layout

```
/src
  /app
    /(public)           # optional route group example
      /page.tsx
    /api                # Route Handlers (server-only)
      /health/route.ts
    /[locale]           # optional i18n segment
    /layout.tsx         # root layout
    /globals.css        # Tailwind base
  /components
    /ui                 # presentational (server by default)
    /client             # client-only widgets ("use client")
  /features             # feature modules (composed UIs for domains)
  /domains              # optional domain modules (models, mappers)
  /services             # server-only data access (HTTP/DB/adapters)
  /lib                  # utilities, types, cache tag helpers
  /store                # optional global client stores (zustand/redux)
  /hooks                # client hooks
  /styles               # Tailwind layer extensions, CSS vars
/tests                  # unit/component tests
```

Notes

* `src/services/*` is server-only by convention; avoid importing from Client Components.
* Use `@/*` path alias → `src/*`.

---

## Pattern Implementations (authoritative scaffolds)

### 1) Container–Presentational (App Router)

`src/app/(catalog)/products/page.tsx` (Server Component container)

```tsx
// Server Component (no "use client")
import { listProducts } from '@/services/catalog';
import ProductList from '@/components/ui/ProductList';

export const revalidate = 900; // ISR-style revalidation

export default async function ProductsPage() {
  const products = await listProducts({ next: { revalidate } });
  return <ProductList products={products} />;
}
```

`src/components/ui/ProductList.tsx` (Presentational; server by default)

```tsx
type Product = { id: string; name: string };
export default function ProductList({ products }: { products: Product[] }) {
  return (
    <ul className="grid gap-3">
      {products.map(p => (
        <li key={p.id} className="rounded border p-3">{p.name}</li>
      ))}
    </ul>
  );
}
```

If interactivity is required:
`src/components/client/FilterBar.tsx` (Client Component)

```tsx
"use client";
import { useState } from 'react';

export function FilterBar({ onChange }: { onChange: (q: string) => void }) {
  const [q, setQ] = useState('');
  return (
    <div className="flex gap-2">
      <input
        className="input input-bordered"
        value={q}
        onChange={e => setQ(e.target.value)}
        placeholder="Filter…"
      />
      <button className="btn" onClick={() => onChange(q)}>Apply</button>
    </div>
  );
}
```

### 2) Data Fetching (Server-first)

`src/services/catalog.ts`

```ts
export async function listProducts(init?: RequestInit & { next?: { revalidate?: number; tags?: string[] } }) {
  const res = await fetch(`${process.env.API_BASE}/products`, {
    ...init,
    next: init?.next ?? { revalidate: 900 }
  });
  if (!res.ok) throw new Error('Failed to load products');
  return res.json() as Promise<Array<{ id: string; name: string }>>;
}
```

Static params for dynamic routes:
`src/app/(catalog)/products/[id]/page.tsx`

```tsx
import { getProduct, listProductIds } from '@/services/catalog';

export async function generateStaticParams() {
  const ids = await listProductIds();
  return ids.map(id => ({ id }));
}

export const revalidate = 3600;

export default async function ProductDetail({ params }: { params: { id: string } }) {
  const product = await getProduct(params.id, { next: { revalidate } });
  return <pre>{JSON.stringify(product, null, 2)}</pre>;
}
```

Dynamic rendering when necessary:

```
export const dynamic = 'force-dynamic'; // per-route
// or: export const fetchCache = 'force-no-store';
```

Cache tagging for selective invalidation:

```
await fetch(url, { next: { tags: ['products'] } });
// later: revalidateTag('products') in a route handler or server action
```

### 3) Routing and API

Route handler under App Router:
`src/app/api/products/route.ts`

```ts
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json([{ id: '1', name: 'Ada Lovelace T-Shirt' }]);
}
```

Layouts and metadata:
`src/app/layout.tsx`

```tsx
import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: { default: 'App', template: '%s · App' },
  description: 'Generic domain app'
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-white text-gray-900">{children}</body>
    </html>
  );
}
```

### 4) State Management (minimal by default)

Zustand example (opt-in):
`src/store/useCart.ts`

```ts
"use client";
import { create } from 'zustand';
type Item = { id: string; qty: number };
type CartState = { items: Item[]; add: (id: string, qty?: number) => void };

export const useCart = create<CartState>(set => ({
  items: [],
  add: (id, qty = 1) => set(s => ({ items: [...s.items, { id, qty }] }))
}));
```

Prefer Server Actions for mutations; fall back to route handlers when sharing across clients:

```tsx
// in a Server Component file
export async function addItem(formData: FormData) {
  'use server';
  // mutate database or call API, then optionally revalidateTag('cart')
}
```

### 5) Error, Loading, Not Found

At any segment (or root):

* `error.tsx` (Client Component; handles render/runtime errors)
* `not-found.tsx` (404 for segment)
* `loading.tsx` (suspense fallback while server work streams)
* Optionally `global-error.tsx` at project root

Example:
`src/app/error.tsx`

```tsx
"use client";
export default function GlobalError({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <html>
      <body className="p-8">
        <h1 className="text-xl font-semibold">Something went wrong.</h1>
        <pre className="mt-4 text-sm text-red-700">{error.message}</pre>
        <button className="btn mt-6" onClick={() => reset()}>Try again</button>
      </body>
    </html>
  );
}
```

---

## Tailwind Styling (authoritative setup)

Install (recorded by task tooling):

* `tailwindcss postcss autoprefixer`

Files:

* `tailwind.config.ts`

```ts
import type { Config } from 'tailwindcss';

export default {
  content: ['./src/**/*.{ts,tsx}'],
  theme: { extend: {} },
  plugins: []
} satisfies Config;
```

* `postcss.config.js`

```js
module.exports = { plugins: { tailwindcss: {}, autoprefixer: {} } };
```

* `src/app/globals.css`

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

/* example tokens */
:root { --radius: 0.5rem; }
```

Component conventions:

* Use semantic wrappers and utility classes; extract repeated patterns into `@layer components` or small UI components.
* Avoid CSS Modules unless encapsulation is required; Tailwind is the default.

---

## Data Fetching Decision Table (for codegen)

| Use case                           | App Router choice                                               |
| ---------------------------------- | --------------------------------------------------------------- |
| Marketing/blog/docs (rare updates) | Static Server Components + `export const revalidate = N`        |
| Personalized dashboard             | `dynamic = 'force-dynamic'` or `fetchCache = 'force-no-store'`  |
| Large catalogs w/ detail pages     | `generateStaticParams` for IDs + `revalidate`                   |
| Partial, frequently updated views  | Static with cache tags; call `revalidateTag('tag')` on mutation |
| Mutations                          | Server Actions (preferred) or `app/api/*` route handlers        |

---

## Generated Files (authoritative)

* `package.json` (scripts: dev, build, start, lint, test)
* `tsconfig.json` (strict; `@/*` → `src/*`)
* `next.config.ts` (project defaults; App Router enabled by default)
* Tailwind: `tailwind.config.ts`, `postcss.config.js`, `src/app/globals.css`
* App Router: `src/app/layout.tsx`, `src/app/page.tsx`, `src/app/error.tsx`, `src/app/not-found.tsx`, `src/app/loading.tsx`
* API: `src/app/api/health/route.ts`
* Example feature: `src/app/(catalog)/products/page.tsx`, `src/components/ui/ProductList.tsx`
* Services: `src/services/*`
* Tooling: `.eslintrc.json`, `.prettier*`, `.gitignore`, `jest.config.ts`

---

## Agentic AI Pipeline: Tasks

### TASK 01 — Scaffold Next.js (App Router + Tailwind)

1. Initialize Next.js with TS and App Router.
2. Add Tailwind (configs + globals).
3. Write base files listed above (layout, page, api/health).
4. Create `@` alias mapping in `tsconfig.json`.

Conformance

* `yarn dev` boots; `/api/health` returns 200.
* Tailwind classes render styles on `/`.

### TASK 02 — Implement Data Fetching by Route

1. For each route spec, choose rendering: `static` (with `revalidate`) or `dynamic`.
2. Generate server containers under `app/*` calling `src/services/*`.
3. Add `generateStaticParams` for dynamic static routes.
4. If `tags` provided, apply `next: { tags }` and emit revalidation hook.

Conformance

* No client data fetching in presentational components.
* Services imported only into server boundaries.

### TASK 03 — Routing Topology and API

1. Create segment layouts and route groups from the spec.
2. Generate `app/api/*` mocks when enabled.

### TASK 04 — State Strategy and Mutations

1. Default to server actions for mutations.
2. If `global_state=redux|zustand`, scaffold store and wire in client components only.

### TASK 05 — Error/Loading/NotFound + Monitoring

1. Emit `error.tsx`, `loading.tsx`, `not-found.tsx` per segment.
2. If monitoring requested, add provider hooks (Sentry or equivalent) client/server.

---

## Pattern Inputs

### 1) Project metadata

* `name` (string, required)
* `description` (string, required)
* `author` (string, optional)
* `license` (string, default: MIT)

### 2) Repository context

* `target_repo_root` (absolute path, required)
* `package_manager` (npm|yarn|pnpm, default: npm)
* `init_git` (boolean, default: true)

### 3) Runtime

* `node_version` (string semver, default: "20.x")

### 4) Routing mode

* `router` (enum: app, fixed to app for this pattern)
* `source_dir` (string, default: "src")

### 5) Route specifications (authoritative, App Router)

Each route:

* `path` (string; e.g., "/", "/products", "/products/[id]")
* `render` (enum: "static" | "dynamic")
* `revalidate` (integer seconds; valid only when `render=static`)
* `params` (enum: "none" | "generate-static" | "dynamic-only", default: "none")
* `data_source` (enum: "service" | "inline", default: "service")
* `service_name` (string; required if `data_source=service`)
* `cache_tags` (string[]; optional, for selective revalidation)
* `seo` (title, description; optional)
* `generate_test` (boolean, default: true)

### 6) API mocks (optional)

* `enabled` (boolean, default: true)
* `endpoints[]` with:

  * `method` (GET|POST|PUT|PATCH|DELETE)
  * `route` (string; `/api/...`)
  * `response_schema` (JSON Schema | ref)
  * `example` (object, optional)
  * `status` (int, default: 200)

### 7) Services layer

* `base_url` (string)
* `headers` (record<string,string>)
* `timeout_ms` (int, default: 15000)
* `retry` (attempts, backoff_ms)

### 8) Global state

* `kind` (enum: context|redux|zustand, default: context)

### 9) Errors & monitoring

* `emit_error_pages` (boolean, default: true)
* `monitoring.provider` (enum: sentry|none, default: none)
* `monitoring.dsn` (string if provider=sentry)

### 10) Tooling

* `eslint` (boolean, default: true)
* `prettier` (boolean, default: true)
* `testing.enabled` (boolean, default: true)
* `testing.coverage_threshold` (0–100, default: 60)

### 11) Path aliases

* `alias` (object, default: {"@": "src"})

### 12) Environment

* `env_template` (record<string,string>, default: { "API_BASE": "[http://localhost:3000](http://localhost:3000)" })
* `write_env_example` (boolean, default: true)

---

## JSON Schema (pattern_config)

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://bobwares.dev/schemas/nextjs-scalable-app-router.pattern.json",
  "title": "Next.js Scalable (App Router) Pattern",
  "type": "object",
  "required": ["name", "description", "target_repo_root", "routes"],
  "properties": {
    "name": { "type": "string", "minLength": 1 },
    "description": { "type": "string", "minLength": 1 },
    "author": { "type": "string" },
    "license": { "type": "string", "default": "MIT" },

    "target_repo_root": { "type": "string", "minLength": 1 },
    "package_manager": { "type": "string", "enum": ["npm", "yarn", "pnpm"], "default": "npm" },
    "init_git": { "type": "boolean", "default": true },

    "node_version": { "type": "string", "default": "20.x" },
    "router": { "type": "string", "enum": ["app"], "default": "app" },
    "source_dir": { "type": "string", "default": "src" },

    "routes": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "required": ["path", "render"],
        "properties": {
          "path": { "type": "string", "pattern": "^/.*" },
          "render": { "type": "string", "enum": ["static", "dynamic"] },
          "revalidate": { "type": "integer", "minimum": 1 },
          "params": { "type": "string", "enum": ["none", "generate-static", "dynamic-only"], "default": "none" },
          "data_source": { "type": "string", "enum": ["service", "inline"], "default": "service" },
          "service_name": { "type": "string" },
          "cache_tags": { "type": "array", "items": { "type": "string" } },
          "seo": {
            "type": "object",
            "properties": {
              "title": { "type": "string" },
              "description": { "type": "string" }
            },
            "additionalProperties": false
          },
          "generate_test": { "type": "boolean", "default": true }
        },
        "allOf": [
          {
            "if": { "properties": { "render": { "const": "static" } } },
            "then": { "required": ["revalidate"] }
          },
          {
            "if": { "properties": { "data_source": { "const": "service" } } },
            "then": { "required": ["service_name"] }
          }
        ],
        "additionalProperties": false
      }
    },

    "api_mocks": {
      "type": "object",
      "properties": {
        "enabled": { "type": "boolean", "default": true },
        "endpoints": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["method", "route"],
            "properties": {
              "method": { "type": "string", "enum": ["GET", "POST", "PUT", "PATCH", "DELETE"] },
              "route": { "type": "string", "pattern": "^/api/.*" },
              "response_schema": {},
              "example": { "type": "object" },
              "status": { "type": "integer", "default": 200 }
            },
            "additionalProperties": false
          }
        }
      },
      "additionalProperties": false
    },

    "services": {
      "type": "object",
      "properties": {
        "base_url": { "type": "string" },
        "headers": { "type": "object", "additionalProperties": { "type": "string" } },
        "timeout_ms": { "type": "integer", "default": 15000 },
        "retry": {
          "type": "object",
          "properties": {
            "attempts": { "type": "integer", "default": 0 },
            "backoff_ms": { "type": "integer", "default": 0 }
          },
          "additionalProperties": false
        }
      },
      "additionalProperties": false
    },

    "state": {
      "type": "object",
      "properties": {
        "kind": { "type": "string", "enum": ["context", "redux", "zustand"], "default": "context" }
      },
      "additionalProperties": false
    },

    "errors": {
      "type": "object",
      "properties": {
        "emit_error_pages": { "type": "boolean", "default": true },
        "monitoring": {
          "type": "object",
          "properties": {
            "provider": { "type": "string", "enum": ["sentry", "none"], "default": "none" },
            "dsn": { "type": "string" }
          },
          "allOf": [
            {
              "if": { "properties": { "provider": { "const": "sentry" } } },
              "then": { "required": ["dsn"] }
            }
          ],
          "additionalProperties": false
        }
      },
      "additionalProperties": false
    },

    "tooling": {
      "type": "object",
      "properties": {
        "eslint": { "type": "boolean", "default": true },
        "prettier": { "type": "boolean", "default": true },
        "testing": {
          "type": "object",
          "properties": {
            "enabled": { "type": "boolean", "default": true },
            "coverage_threshold": { "type": "number", "minimum": 0, "maximum": 100, "default": 60 }
          },
          "additionalProperties": false
        }
      },
      "additionalProperties": false
    },

    "alias": {
      "type": "object",
      "default": { "@": "src" },
      "additionalProperties": { "type": "string" }
    },

    "env": {
      "type": "object",
      "properties": {
        "env_template": { "type": "object", "additionalProperties": { "type": "string" } },
        "write_env_example": { "type": "boolean", "default": true }
      },
      "additionalProperties": false
    }
  },
  "additionalProperties": false
}
```

---

## Minimal example

```json
{
  "name": "next-app-tailwind-starter",
  "description": "App Router + Tailwind scaffold, domain-agnostic.",
  "target_repo_root": "/workspace/next-app-tailwind-starter",
  "routes": [
    { "path": "/", "render": "static", "revalidate": 600, "data_source": "inline" },
    { "path": "/products", "render": "static", "revalidate": 900, "data_source": "service", "service_name": "catalog.listProducts", "cache_tags": ["products"] },
    { "path": "/products/[id]", "render": "static", "revalidate": 3600, "params": "generate-static", "data_source": "service", "service_name": "catalog.getProduct" }
  ],
  "services": { "base_url": "http://localhost:3000" },
  "env": { "env_template": { "API_BASE": "http://localhost:3000" } }
}
```

---

If you want this emitted as `agentic-pipeline/patterns/nextjs-scalable-app-router.md` with your pipeline headers, say so and I’ll output it in-place with that path and exact structure.
