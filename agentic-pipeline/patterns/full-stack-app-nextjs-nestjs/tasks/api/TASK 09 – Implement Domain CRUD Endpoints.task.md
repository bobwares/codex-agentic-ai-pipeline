# Task 09 – Implement Domain CRUD Endpoints 


## Inputs

- project.domain.Domain Object

## Outputs

### Controller

- Create nestjs Controller with routes:

    - `GET    /{{project.domain.Domain Object}}`        → list all domain records
    - `GET    /{{project.domain.Domain Object}}/:id`    → fetch one domain record by ID
    - `POST   /{{project.domain.Domain Object}}`        → create a new domain record
    - `PUT    /{{project.domain.Domain Object}}/:id`    → update an existing domain record
    - `DELETE /{{project.domain.Domain Object}}/:id`    → remove a domain record
- Add NestJS Swagger decorators on each route:

    - `@ApiTags('{{project.domain.Domain Object}}')`
    - `@ApiOperation({ summary: '...' })`
    - `@ApiOkResponse(...)`, `@ApiCreatedResponse(...)`, `@ApiNoContentResponse(...)`, `@ApiBadRequestResponse(...)`, `@ApiNotFoundResponse(...)`
    - `@ApiParam({ name: 'id', type: String })` (or Number/UUID as appropriate)

### Service

- inject  {{project.domain.Domain Object}}Service into controller.

### DTOs

- generate
  - Create{{project.domain.Domain Object}}Dto
  - Update{{project.domain.Domain Object}}Dto
  - Response{{project.domain.Domain Object}}Dto
  - match the schema fields, with `class-validator` decorators.
  - Annotate DTOs with `@ApiProperty()` (and `@ApiPropertyOptional()`) including `description`, `example`, and constraints derived from the JSON schema.


### OPENAPI

- add OpenAPI Bootstrapping
- In `main.ts`, enable global validation pipes and set up Swagger using `SwaggerModule`:

    - Title: `{{project.name}} API`
    - Version: read from `package.json`
    - Docs UI at `/api/docs`
    - JSON spec served at `/api/openapi.json` and YAML at `/api/openapi.yaml` (optional file writer step described below)
- Add an error model (Problem Details shape) and reference it in `@Api*Response({ schema: ... })` or a typed class.

- Spec Generation
  - Add an `npm` script to emit `openapi.json` (and `.yaml`) to `project_root/api/openapi/` by running the Nest app in a small script or CLI bootstrap that calls `SwaggerModule.createDocument` and writes files to disk.
  - Provide an optional Spectral or OpenAPI schema validation step in CI that lints `openapi.json`.

### Testing

    * Add an end-to-end test suite in `project_root/api/test/{{project.domain.Domain Object}}.e2e-spec.ts` covering all CRUD routes.
    * Add an assertion that `/api/openapi.json` returns a valid OpenAPI 3.1 document and that all five CRUD paths exist.

### .http Smoke Tests**

    * Provide `project_root/api/e2e/{{project.domain.Domain Object}}s.http` including calls to each route and a request to `/api/openapi.json`.


## Outputs

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

