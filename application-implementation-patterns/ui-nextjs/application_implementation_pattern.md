# Application Implementation Pattern: Next.js Scalable (App Router + Tailwind)

This pattern is domain-agnostic and can host any business domain via feature or domain modules.

# Use Case

Use when you want a scalable, maintainable web UI using the App Router (`app/`) with server components by default, route handlers in `app/api`, streaming/Suspense, and granular caching/revalidation. Works for marketing sites, dashboards, CRUD, and data apps. Tailwind provides consistent utility-first styling.

## Purpose

Codify five key design patterns:

- Container/Presentational
- Data Fetching
- Routing
- State Management
- Error Handling


## Tech Stack


- Runtime

  - Node.js 20 LTS

- Package manager

  - npm

- Core frameworks

  - Next.js 15.1.0 
  - React 19.2.0 

- Language

  - TypeScript 5.9.x 

- Styling

  - Tailwind CSS ^3.4
  - PostCSS ^8.4
  - Autoprefixer ^10.4

- State management

  - Server state: @tanstack/react-query ^5
  - Local/UI state: Zustand ^4 
  - Context API: read-mostly globals 

- Forms and validation

  - react-hook-form ^7
  - zod ^3 (schemas shared across server and client)

- Linting and formatting

  - eslint-config-next ^15
  - @typescript-eslint/parser ^8
  - @typescript-eslint/eslint-plugin ^8
  - Prettier ^3

- Testing

  - Unit/integration: Vitest ^2, @testing-library/react ^16, @testing-library/user-event ^14, jsdom ^24
  - E2E: Playwright ^1.47

- Build/DX

  - SWC (Next default)
  - server-only/client-only guards
  - tsconfig paths; minimal aliases
  - .nvmrc for Node 20; .npmrc for consistent npm behavior
  - GitHub Actions: typecheck, unit, E2E, and agent dry-run plan jobs

- Agent control glue

  - Next Route Handlers as the API surface for agent commands
  - Optional queue: BullMQ ^5 + Redis (for long-running tasks)
  - Spec inputs: PRD + AGENTS.md + workflow YAML validated with zod

- Version constraints to pin in package.json

  - next: "15.x"
  - react: "19.x"
  - react-dom: "19.x"
  - typescript: "5.9.x"
  - eslint-config-next: "^15"
  - @typescript-eslint/parser: "^8"
  - @typescript-eslint/eslint-plugin: "^8"
  - tailwindcss: "^3.4"
  - postcss: "^8.4"
  - autoprefixer: "^10.4"
  - @tanstack/react-query: "^5"
  - zustand: "^4"
  - react-hook-form: "^7"
  - zod: "^3"
  - vitest: "^2"
  - @testing-library/react: "^16"
  - @testing-library/user-event: "^14"
  - jsdom: "^24"
  - playwright: "^1.47"
  - bullmq: "^5"
  - ioredis: "^5"


---

## Directory Layout

```
/public                     # static assets (favicon, og images)
/src
  /app
    /(public)               # optional route group
      /page.tsx
    /api                    # Route Handlers (server-only)
      /health/route.ts
    /[locale]               # optional i18n segment
    /layout.tsx             # root layout (imports globals.css)
    /globals.css            # Tailwind base

  /components
    /ui                     # presentational (RSC by default)
    /client                 # client-only widgets ("use client")

  /features                 # feature modules (composed UIs for domains)
    /registration
      /components
      /actions              # server actions for this feature ("use server")
      /queries              # react-query hooks (client)
      /types
      /test                 # colocated tests (optional)

  /domains                  # domain models, mappers, validation schemas (zod)
  /server                   # server-only modules (DB/HTTP/adapters) [guarded by server-only]
  /lib                      # shared utils, types, cache tag helpers (client-safe only)
  /store                    # global client stores (zustand); no server imports
  /hooks
    /client                 # client hooks (useEffect/useState)
    /server                 # typed helpers for actions/route handlers (no React hooks)
  /styles                   # Tailwind layer extensions, CSS vars

/tests                      # central test folder (if not colocating)
  /integration              # Vitest + RTL + jsdom
  /e2e                      # Playwright

next.config.mjs
tsconfig.json
env.d.ts                    # augment import.meta types (Vite) or process.env typings
vitest.config.ts
playwright.config.ts
.eslintrc.cjs               # or flat config
.prettierrc
.nvmrc
.npmrc
.github/workflows/ci.yml

```

---

## Example  

### 1) Container–Presentational (App Router)

`src/app/(catalog)/products/page.tsx` (Server Component container)

```tsx
// Server Component (no "use client")
import { listProducts } from '@/services/catalog';
import ProductList from '@/components/ui/ProductList';

export const revalidate = 900; // seconds

export default async function ProductsPage() {
  const products = await listProducts({ next: { revalidate, tags: ['products'] } });
  return <ProductList products={products} />;
}
```

`src/components/ui/ProductList.tsx` (presentational; server by default)

```tsx
export type Product = { id: string; name: string };

export default function ProductList({ products }: { products: Product[] }) {
  return (
    <ul className="grid gap-3">
      {products.map((p) => (
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
        className="border rounded px-3 py-2"
        value={q}
        onChange={(e) => setQ(e.target.value)}
        placeholder="Filter…"
      />
      <button
        type="button"
        className="border rounded px-3 py-2"
        onClick={() => onChange(q)}
      >
        Apply
      </button>
    </div>
  );
}
```

### 2) Data Fetching (Server-first, typed, cache-aware)

`src/lib/env.ts`

```ts
export const API_BASE = process.env.API_BASE;
if (!API_BASE) {
  throw new Error('Missing API_BASE env var (server only)');
}
```

`src/services/catalog.ts`

```ts
import { API_BASE } from '@/lib/env';
import type { Product } from '@/components/ui/ProductList';

type NextOpts = { next?: { revalidate?: number; tags?: string[] } };

export async function listProducts(
  init?: RequestInit & NextOpts
): Promise<Product[]> {
  const res = await fetch(`${API_BASE}/products`, {
    ...init,
    next: init?.next ?? { revalidate: 900, tags: ['products'] },
  });
  if (!res.ok) throw new Error(`Products load failed: ${res.status}`);
  return res.json() as Promise<Product[]>;
}

export async function getProduct(
  id: string,
  init?: RequestInit & NextOpts
): Promise<Product> {
  const res = await fetch(`${API_BASE}/products/${id}`, {
    ...init,
    next: init?.next ?? {
      revalidate: 900,
      tags: ['products', `product:${id}`],
    },
  });
  if (!res.ok) throw new Error(`Product ${id} load failed: ${res.status}`);
  return res.json() as Promise<Product>;
}

export async function listProductIds(): Promise<string[]> {
  const res = await fetch(`${API_BASE}/products/ids`, {
    next: { revalidate: 3600, tags: ['products'] },
  });
  if (!res.ok) throw new Error(`Product ids load failed: ${res.status}`);
  return res.json() as Promise<string[]>;
}
```

Static params for dynamic routes (use only when the ID set is modest and stable):

`src/app/(catalog)/products/[id]/page.tsx`

```tsx
import { getProduct, listProductIds } from '@/services/catalog';

export async function generateStaticParams() {
  const ids = await listProductIds();
  return ids.map((id) => ({ id }));
}

export const revalidate = 3600;

export default async function ProductDetail({
  params,
}: {
  params: { id: string };
}) {
  const product = await getProduct(params.id, { next: { revalidate } });
  return <pre>{JSON.stringify(product, null, 2)}</pre>;
}
```

Dynamic rendering (when data is highly volatile):

```ts
export const dynamic = 'force-dynamic';
// or: export const fetchCache = 'force-no-store';
```

Cache tagging for selective invalidation:

```ts
await fetch(url, { next: { tags: ['products'] } });
// later (server): revalidateTag('products')
```

### 3) Routing and API

`src/app/api/products/route.ts`

```ts
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json([{ id: '1', name: 'Ada Lovelace T-Shirt' }], {
    headers: { 'cache-control': 'public, s-maxage=900, stale-while-revalidate=60' },
  });
}
```

Optional tag revalidation endpoint:

`src/app/api/products/revalidate/route.ts`

```ts
import { revalidateTag } from 'next/cache';
import { NextResponse } from 'next/server';

export async function POST() {
  revalidateTag('products');
  return NextResponse.json({ ok: true });
}
```

Layouts and metadata:

`src/app/layout.tsx`

```tsx
import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: { default: 'App', template: '%s · App' },
  description: 'Generic domain app',
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

Zustand (opt-in):

`src/store/useCart.ts`

```ts
"use client";
import { create } from 'zustand';

type Item = { id: string; qty: number };
type CartState = {
  items: Item[];
  add: (id: string, qty?: number) => void;
};

export const useCart = create<CartState>((set) => ({
  items: [],
  add: (id, qty = 1) =>
    set((s) => ({ items: [...s.items, { id, qty }] })),
}));
```

Prefer Server Actions for mutations; optionally combine with cache tag invalidation:

`src/features/cart/actions.ts`

```ts
'use server';
import { revalidateTag } from 'next/cache';

export async function addItem(formData: FormData) {
  const id = String(formData.get('id') ?? '');
  const qty = Number(formData.get('qty') ?? 1);
  // perform mutation (DB/API call) here
  revalidateTag('cart');
}
```

### 5) Error, Loading, Not Found

At any segment (or root):

- `error.tsx` (Client Component; handles render/runtime errors)
- `not-found.tsx` (404 for segment)
- `loading.tsx` (Suspense fallback while server work streams)
- Optionally `global-error.tsx` at project root

`src/app/error.tsx`

```tsx
"use client";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <html>
      <body className="p-8">
        <h1 className="text-xl font-semibold">Something went wrong.</h1>
        <pre className="mt-4 text-sm text-red-700 whitespace-pre-wrap">
          {error.message}
        </pre>
        <button
          type="button"
          className="border rounded px-3 py-2 mt-6"
          onClick={() => reset()}
        >
          Try again
        </button>
      </body>
    </html>
  );
}
```

---
## Tailwind Styling 

- Files

  - tailwind.config.ts

    ```ts
    import type { Config } from 'tailwindcss';

    const config = {
      darkMode: ['class'],
      content: ['./src/**/*.{ts,tsx,md,mdx}'],
      theme: {
        extend: {
          borderRadius: { DEFAULT: 'var(--radius)' },
          container: {
            center: true,
            padding: '1rem',
            screens: { '2xl': '72rem' }
          },
          colors: {
            brand: {
              DEFAULT: 'rgb(var(--color-brand))',
              foreground: 'rgb(var(--color-brand-foreground))'
            }
          }
        }
      },
      plugins: [],
      // safelist: ['text-left', 'text-center', 'text-right']
    } satisfies Config;

    export default config;
    ```

  - postcss.config.js

    ```js
    module.exports = {
      plugins: {
        tailwindcss: {},
        autoprefixer: {}
      }
    };
    ```

  - src/app/globals.css

    ```css
    @tailwind base;
    @tailwind components;
    @tailwind utilities;

    :root {
      --radius: 0.5rem;
      --color-brand: 34 197 94;
      --color-brand-foreground: 255 255 255;
    }

    :root.dark {
      --color-brand: 22 163 74;
      --color-brand-foreground: 255 255 255;
    }

    @layer components {
      .btn {
        @apply inline-flex items-center justify-center rounded px-3 py-2 font-medium
          bg-[rgb(var(--color-brand))] text-[rgb(var(--color-brand-foreground))]
          hover:opacity-95;
      }

      .card {
        @apply rounded-lg border p-4 bg-white shadow-sm;
      }
    }

    @layer utilities {
      .focus-ring {
        @apply outline-none ring-2 ring-offset-2 ring-[rgb(var(--color-brand))];
      }
    }
    ```

- package.json updates

  ```json
  {
    "devDependencies": {
      "tailwindcss": "^3.4",
      "postcss": "^8.4",
      "autoprefixer": "^10.4",
      "prettier-plugin-tailwindcss": "^0.6.8"
    }
  }
  ```

- Usage notes

  - Import src/app/globals.css once in src/app/layout.tsx.
  - content includes ts, tsx, md, mdx under src to cover RSC, client components, and MDX.
  - plugins are empty by default; add specific Tailwind plugins only when required and ensure corresponding devDependencies are present.
  - enable safelist only when generating class names dynamically.

- Component conventions

  - Use semantic HTML wrappers with Tailwind utilities by default.
  - Extract repeated utility patterns into one of:

    - @layer components rules in src/app/globals.css for tokenized, app-wide primitives.
    - small reusable React components in src/components/ui for markup plus behavior.
  - CSS Modules are allowed only when strict encapsulation is required.

---

## Data Fetching Decision Table (for codegen)

| Use case                           | App Router choice                                                                          |
| ---------------------------------- | ------------------------------------------------------------------------------------------ |
| Marketing/blog/docs (rare updates) | Static Server Components + `export const revalidate = <seconds>`                           |
| Personalized dashboard             | `export const dynamic = 'force-dynamic'` (or `export const fetchCache = 'force-no-store'`) |
| Large catalogs with detail pages   | `generateStaticParams` for stable ID sets + `revalidate` on product/detail pages           |
| Partial, frequently updated views  | Static + fetch with `next: { tags: [...] }`; mutate then `revalidateTag('<tag>')`          |
| Mutations                          | Server Actions (preferred); else `app/api/*` route handlers                                |


---


## Pattern Inputs (authoritative for codegen)

### 1) Project metadata

- name: string (required)
- description: string (required)
- author: string (required)
- license: string = "MIT"

### 2) Repository context

- target_repo_root: absolute path (required)
- package_manager: "npm" (required)
- init_git: boolean = true

### 3) Runtime

- node_version: string semver = "20.x"

### 4) Routing mode

- router: "app" (required)
- source_dir: string = "src"

### 5) Route specifications (App Router)

Each route object:

- path: string (e.g., "/", "/products", "/products/[id]") (required)
- render: "static" | "dynamic" (required)
- revalidate: integer seconds (required when render = "static"; must be omitted when render = "dynamic")
- params: "none" | "generate-static" | "dynamic-only" (required)
- data_source: "service" | "inline" (required)
- service_name: string (required when data_source = "service")
- cache_tags: string[] (required; use [] if none)
- seo: { title: string; description: string } (required)
- generate_test: boolean = true

### 6) API mocks

- enabled: boolean = true
- endpoints: array of:

  - method: "GET" | "POST" | "PUT" | "PATCH" | "DELETE" (required)
  - route: string (e.g., "/api/health") (required)
  - response_schema: JSON Schema object or "$ref" string (required)
  - example: object (required)
  - status: integer = 200

### 7) Services layer

- base_url: string (required)
- headers: record<string,string> (required; use {} if none)
- timeout_ms: integer = 15000
- retry: { attempts: integer; backoff_ms: integer } (required)

### 8) Global state

- kind: "zustand" (required)

### 9) Errors & monitoring

- emit_error_pages: boolean = true
- monitoring: { provider: "none" | "sentry"; dsn: string }

  - provider is required; when provider = "sentry", dsn is required.

### 10) Tooling

- eslint: boolean = true
- prettier: boolean = true
- testing: { enabled: boolean = true; coverage_threshold: number 0–100 = 60; runner: "vitest"; e2e: "playwright" } (required)

### 11) Path aliases

- alias: record<string,string> = { "@": "src" }

### 12) Environment

- env_template: record<string,string> = { "API_BASE": "[http://localhost:3000](http://localhost:3000)" }
- write_env_example: boolean = true



This version tells the agent exactly what to generate and when, with fixed defaults and conditional requirements—no “optional” decisions left to the model.

---

## Example JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://bobwares.dev/schemas/nextjs-scalable-app-router.pattern.v1.json",
  "title": "Next.js Scalable (App Router) Pattern",
  "type": "object",
  "required": [
    "pattern_version",
    "name",
    "description",
    "target_repo_root",
    "package_manager",
    "node_version",
    "router",
    "source_dir",
    "routes",
    "services",
    "api_mocks",
    "state",
    "errors",
    "tooling",
    "alias",
    "env"
  ],
  "properties": {
    "pattern_version": { "type": "string", "const": "1.0.0" },

    "name": { "type": "string", "minLength": 1 },
    "description": { "type": "string", "minLength": 1 },
    "author": { "type": "string" },
    "license": { "type": "string", "default": "MIT" },

    "target_repo_root": { "type": "string", "minLength": 1 },

    "package_manager": { "type": "string", "const": "npm" },

    "node_version": { "type": "string", "const": "20.x" },

    "router": { "type": "string", "const": "app" },

    "source_dir": { "type": "string", "default": "src" },

    "routes": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "required": [
          "path",
          "render",
          "params",
          "data_source",
          "cache_tags",
          "seo",
          "generate_test"
        ],
        "properties": {
          "path": { "type": "string", "pattern": "^/.*" },
          "render": { "type": "string", "enum": ["static", "dynamic"] },
          "revalidate": { "type": "integer", "minimum": 1 },
          "params": {
            "type": "string",
            "enum": ["none", "generate-static", "dynamic-only"]
          },
          "data_source": { "type": "string", "enum": ["service", "inline"] },
          "service_name": { "type": "string" },
          "cache_tags": {
            "type": "array",
            "items": { "type": "string" }
          },
          "seo": {
            "type": "object",
            "required": ["title", "description"],
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
      "required": ["enabled", "endpoints"],
      "properties": {
        "enabled": { "type": "boolean", "default": true },
        "endpoints": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["method", "route", "status"],
            "properties": {
              "method": {
                "type": "string",
                "enum": ["GET", "POST", "PUT", "PATCH", "DELETE"]
              },
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
      "required": ["base_url", "headers", "retry"],
      "properties": {
        "base_url": { "type": "string", "minLength": 1 },
        "headers": {
          "type": "object",
          "additionalProperties": { "type": "string" },
          "default": {}
        },
        "timeout_ms": { "type": "integer", "default": 15000 },
        "retry": {
          "type": "object",
          "required": ["attempts", "backoff_ms"],
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
      "required": ["kind"],
      "properties": {
        "kind": { "type": "string", "const": "zustand" }
      },
      "additionalProperties": false
    },

    "errors": {
      "type": "object",
      "required": ["emit_error_pages", "monitoring"],
      "properties": {
        "emit_error_pages": { "type": "boolean", "default": true },
        "monitoring": {
          "type": "object",
          "required": ["provider"],
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
      "required": ["eslint", "prettier", "testing"],
      "properties": {
        "eslint": { "type": "boolean", "default": true },
        "prettier": { "type": "boolean", "default": true },
        "testing": {
          "type": "object",
          "required": ["enabled", "coverage_threshold", "runner", "e2e"],
          "properties": {
            "enabled": { "type": "boolean", "default": true },
            "coverage_threshold": {
              "type": "number",
              "minimum": 0,
              "maximum": 100,
              "default": 60
            },
            "runner": { "type": "string", "const": "vitest" },
            "e2e": { "type": "string", "const": "playwright" }
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
      "required": ["env_template", "write_env_example"],
      "properties": {
        "env_template": {
          "type": "object",
          "default": { "API_BASE": "http://localhost:3000" },
          "additionalProperties": { "type": "string" }
        },
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


## Purpose of the Schema (agent contract)

- Define inputs precisely

  - The JSON Schema is the machine-readable contract derived from the PRD. It enumerates every field the generator accepts, their types, allowed values, and defaults. Nothing outside the schema is allowed.

- Enforce decisions from the PRD

  - Opinionated choices (npm only, App Router, Zustand, Vitest/Playwright, Node 20.x) are encoded as const values. The agent must not override or infer different tools.

- Enable deterministic generation

  - By validating an input document against the schema before any file is written, the agent guarantees the same inputs always produce the same outputs.

- Prevent configuration drift

  - additionalProperties: false blocks unknown fields so the agent cannot “invent” knobs or silently ignore typos.

- Encode cross-field rules

  - if/then rules capture dependencies (example: render = "static" requires revalidate; data_source = "service" requires service_name). The agent must enforce these before codegen.

- Centralize defaults

  - Defaults live in the schema, not in scattered generator code. The agent hydrates them after validation and uses that single hydrated object for generation.

- Support versioning and traceability

  - $id and pattern_version tie a concrete generator to a concrete contract. The agent logs both alongside the generated commit to preserve provenance.

- Boundaries for safety

  - The schema constrains environment, routing, and tooling fields to safe, supported values. The agent must fail fast if inputs request unsupported behavior.

