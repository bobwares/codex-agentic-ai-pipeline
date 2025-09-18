### Task 07 – Swagger / OpenAPI Documentation Endpoint

| Field        | Value                               |
| ------------ | ----------------------------------- |
| **Filename** | `Task 07 – Swagger OpenAPI Docs.md` |
| **T-Ref**    | —                                   |

**Goal**
Expose interactive API docs (`/docs`), downloadable JSON (`/openapi.json`), and ensure every public route is documented.

**Context**

* Consumers (front-end, Postman collection, contract tests) read the OpenAPI spec.
* **AGENTS.md** requires every endpoint be discoverable.

**Acceptance Criteria**

1. `@nestjs/swagger` configured in `main.ts` with:

    * Title: “Full-Stack API”
    * Version read from `package.json`.
    * Servers: dev (`http://localhost:3000`) & prod (`/`).
2. Swagger module guarded by basic auth in non-dev environments.
3. Swagger decorators (`@ApiTags`, `@ApiResponse`, `@ApiBearerAuth`) added to Customer controller.
4. Script `npm run openapi:export` writes `openapi.json` to `project_root/api/docs/`.
5. CI artifact upload of the JSON spec.

**Steps**

1. `npm i @nestjs/swagger swagger-ui-express`.
2. Add Swagger setup in `main.ts`.
3. Annotate DTOs and controllers.
4. Create Node script `scripts/export-swagger.ts`.
5. Update `api/README.md` with usage instructions.

**DoD**

* Visiting `/docs` shows endpoints & schemas.
* Exported file committed in PR.
