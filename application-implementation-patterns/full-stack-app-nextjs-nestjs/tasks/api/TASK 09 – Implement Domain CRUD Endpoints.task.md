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


### Testing

    * Add an end-to-end test suite in `project_root/api/test/{{project.domain.Domain Object}}.e2e-spec.ts` covering all CRUD routes.
    * Add an assertion that `/api/openapi.json` returns a valid OpenAPI 3.1 document and that all five CRUD paths exist.

### .http Smoke Tests**

    * Provide `project_root/api/e2e/{{project.domain.Domain Object}}s.http` including calls to each route and a request to `/api/openapi.json`.
