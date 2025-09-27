# Task 09 – Implement Domain CRUD Endpoints (with OpenAPI)

**Description**
Based on the {{project.domain.Domain Object}} JSON schema, implement a full set of RESTful CRUD endpoints in the backend API (`target_project/api`) and fully document them with OpenAPI (Swagger). The API must expose interactive docs at `/api/docs` and publish a machine-readable spec at `/api/openapi.json`.

* **Controller**

    * Create `CustomerController` with routes:

        * `GET    /{{project.domain.Domain Object}}`        → list all domain records
        * `GET    /{{project.domain.Domain Object}}/:id`    → fetch one domain record by ID
        * `POST   /{{project.domain.Domain Object}}`        → create a new domain record
        * `PUT    /{{project.domain.Domain Object}}/:id`    → update an existing domain record
        * `DELETE /{{project.domain.Domain Object}}/:id`    → remove a domain record
    * Add NestJS Swagger decorators on each route:

        * `@ApiTags('{{project.domain.Domain Object}}')`
        * `@ApiOperation({ summary: '...' })`
        * `@ApiOkResponse(...)`, `@ApiCreatedResponse(...)`, `@ApiNoContentResponse(...)`, `@ApiBadRequestResponse(...)`, `@ApiNotFoundResponse(...)`
        * `@ApiParam({ name: 'id', type: String })` (or Number/UUID as appropriate)

* **Service**

    * Implement `{{project.domain.Domain Object}}Service` with methods: `create()`, `findAll()`, `findOne()`, `update()`, `remove()`.

* **DTOs & Validation**

    * Define `Create{{project.domain.Domain Object}}Dto` and `Update{{project.domain.Domain Object}}Dto` matching the schema fields, with `class-validator` decorators.
    * Annotate DTOs with `@ApiProperty()` (and `@ApiPropertyOptional()`) including `description`, `example`, and constraints derived from the JSON schema.

* **Persistence**

    * Ensure the Domain entity (or model) defined under `libs/domain/` is registered in your ORM (TypeORM/Prisma) and wired into the API module.

* **OpenAPI Bootstrapping**

    * In `main.ts`, enable global validation pipes and set up Swagger using `SwaggerModule`:

        * Title: `{{project.name}} API`
        * Version: read from `package.json`
        * Docs UI at `/api/docs`
        * JSON spec served at `/api/openapi.json` and YAML at `/api/openapi.yaml` (optional file writer step described below)
    * Add an error model (Problem Details shape) and reference it in `@Api*Response({ schema: ... })` or a typed class.

* **Spec Generation**

    * Add an `npm` script to emit `openapi.json` (and `.yaml`) to `project_root/api/openapi/` by running the Nest app in a small script or CLI bootstrap that calls `SwaggerModule.createDocument` and writes files to disk.
    * Provide an optional Spectral or OpenAPI schema validation step in CI that lints `openapi.json`.

* **Testing**

    * Add an end-to-end test suite in `project_root/api/test/{{project.domain.Domain Object}}.e2e-spec.ts` covering all CRUD routes.
    * Add an assertion that `/api/openapi.json` returns a valid OpenAPI 3.1 document and that all five CRUD paths exist.

* **.http Smoke Tests**

    * Provide `project_root/api/e2e/{{project.domain.Domain Object}}s.http` including calls to each route and a request to `/api/openapi.json`.

**Acceptance Criteria**

* `project_root/api/src/{{project.domain.Domain Object}}/{{project.domain.Domain Object}}.controller.ts` contains all five CRUD routes and is annotated with appropriate Swagger decorators.
* `{{project.domain.Domain Object}}Service` and the two DTO classes exist, enforce schema validation, and expose `@ApiProperty` metadata with examples and constraints aligned to the JSON schema.
* The persistence layer correctly maps to the JSON schema and is wired into `ApiModule`.
* `/api/docs` renders Swagger UI; `/api/openapi.json` serves a valid OpenAPI 3.1 spec that includes all CRUD paths, request bodies, parameters, and response schemas.
* `npm run openapi:emit` writes `project_root/api/openapi/openapi.json` (and optionally `openapi.yaml`) and the file validates against the OpenAPI 3.1 schema.
* `{{project.domain.Domain Object}}s.e2e-spec.ts` tests for create, read (all & one), update, and delete operations all pass, and an additional test verifies `/api/openapi.json` structure.
* `project_root/api/README.md` is updated with a “{{project.domain.Domain Object}} API” section documenting each endpoint and a “API Docs” section describing `/api/docs` and `/api/openapi.json`.
* `project_root/README.md` is updated to reference the API docs endpoints and the spec emission script.

**Implementation Notes (concise)**

* `main.ts` (Swagger setup):

    * Build config via `new DocumentBuilder().setTitle(...).setVersion(...).addTag('{{project.domain.Domain Object}}').build()`.
    * `const document = SwaggerModule.createDocument(app, config, { include: [ApiModule] });`
    * `SwaggerModule.setup('/api/docs', app, document);`
    * Add a GET route or static file server for `/api/openapi.json` if not served automatically; optionally write the file to disk when `OPENAPI_EMIT=true`.

* **DTO Example**

    * `@ApiProperty({ description: 'Customer email', example: 'jane.doe@example.com', maxLength: 255 })`
    * Mirror JSON schema constraints (`maxLength`, `format`, `minimum`, etc.) in both `class-validator` and `@ApiProperty` metadata.

* **Error Model**

    * Define `ProblemDetails` DTO with fields `type`, `title`, `status`, `detail`, `instance`; reference in error responses using `@ApiBadRequestResponse({ type: ProblemDetails })`, etc.

* **Export Script**

    * Create `scripts/emit-openapi.ts` that imports the Nest `AppModule`, builds the document, and writes `/openapi/openapi.json` (and `.yaml` if desired).

**Expected Outputs**

* New/updated files under `project_root/api/src/{{project.domain.Domain Object}}/`:

    * `{{project.domain.Domain Object}}.controller.ts` (with `@ApiTags`, per-route `@Api*Response`, `@ApiParam`)
    * `{{project.domain.Domain Object}}.service.ts`
    * `dtos/create-{{project.domain.Domain Object}}.dto.ts` (with `class-validator` and `@ApiProperty`)
    * `dtos/update-{{project.domain.Domain Object}}.dto.ts` (with partial type or explicit optionals and `@ApiPropertyOptional`)
    * `{{project.domain.Domain Object}}.controller.test.ts`
    * `{{project.domain.Domain Object}}.service.test.ts`
    * `dtos/create-{{project.domain.Domain Object}}.dto.test.ts`
    * `dtos/update-{{project.domain.Domain Object}}.dto.test.ts`
    * (if needed) `{{project.domain.Domain Object}}.module.ts` updates to import DTOs/entities and re-export controller/service

* New/updated bootstrap and scripts:

    * `project_root/api/src/main.ts` (SwaggerModule setup, global pipes)
    * `project_root/api/scripts/emit-openapi.ts` (writes `openapi.json` and optionally `.yaml`)
    * `project_root/api/package.json` scripts:

        * `"openapi:emit": "ts-node -r tsconfig-paths/register src/scripts/emit-openapi.ts"`
        * `"openapi:lint"` (optional, if Spectral or validator is added)

* New end-to-end test:

    * `project_root/api/test/{{project.domain.Domain Object}}s.e2e-spec.ts` (CRUD + `/api/openapi.json` presence and basic structure)

* New .http test:

    * `project_root/api/e2e/{{project.domain.Domain Object}}s.http` (CRUD requests + GET `/api/openapi.json`)

* OpenAPI artifacts:

    * `project_root/api/openapi/openapi.json`
    * `project_root/api/openapi/openapi.yaml` (optional)

* Documentation updates:

    * `project_root/api/README.md` (“{{project.domain.Domain Object}} API” and “API Docs” sections with paths and how to regenerate spec)
    * `project_root/README.md` (pointer to `/api/docs` and spec emission script)

**Scope Notes**

* Keep security simple unless otherwise specified. If auth is required, add `@ApiBearerAuth()` and document `401/403` responses.
* Ensure route parameter types and DTO field types match the JSON schema and are reflected in both validation and OpenAPI metadata.
