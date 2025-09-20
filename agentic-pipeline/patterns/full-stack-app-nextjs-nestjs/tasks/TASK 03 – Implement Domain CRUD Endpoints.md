# Task 03 – Implement Domain CRUD Endpoints

**Description**  
Based on the {{project.domain.Domain Object}} JSON schema, implement a full set of RESTful CRUD endpoints in the backend API (`target_project/api`):

- **Controller**
    - Create `CustomerController` with routes:
        - `GET    /{{project.domain.Domain Object}}`        → list all domain records
        - `GET    /{{project.domain.Domain Object}}/:id`    → fetch one domain record by ID
        - `POST   /{{project.domain.Domain Object}}`        → create a new domain record
        - `PUT    /{{project.domain.Domain Object}}/:id`    → update an existing domain record
        - `DELETE /{{project.domain.Domain Object}}/:id`    → remove a domain record
- **Service**
    - Implement `{{project.domain.Domain Object}}Service` with methods: `create()`, `findAll()`, `findOne()`, `update()`, `remove()`.
- **DTOs & Validation**
    - Define `Create{{project.domain.Domain Object}}Dto` and `Update{{project.domain.Domain Object}}Dto` matching the schema fields, with `class-validator` decorators.
- **Persistence**
    - Ensure the Domain entity (or model) defined under `libs/domain/` is registered in your ORM (TypeORM/Prisma) and wired into the API module.
- **Testing**
    - Add an end-to-end test suite in `project_root/api/test/{{project.domain.Domain Object}}.e2e-spec.ts` covering all CRUD routes.

**Acceptance Criteria**
- `project_root/api/src/{{project.domain.Domain Object}}/{{project.domain.Domain Object}}.controller.ts` contains all five CRUD routes.
- `{{project.domain.Domain Object}}Service` and the two DTO classes exist and enforce schema validation.
- The persistence layer correctly maps to the JSON schema and is wired into `ApiModule`.
- `{{project.domain.Domain Object}}s.e2e-spec.ts` tests for create, read (all & one), update, and delete operations all pass.
- `project_root/api/README.md` is updated with a “{{project.domain.Domain Object}} API” section documenting each endpoint.
- A pull request is opened on branch `task-03-create-{{project.domain.Domain Object}}-crud-endpoints`.


**Expected Outputs**
- New/updated files under `project_root/api/src/{{project.domain.Domain Object}}/`:
    - `{{project.domain.Domain Object}}.controller.ts`
    - `{{project.domain.Domain Object}}.service.ts`
    - `dtos/create-{{project.domain.Domain Object}}.dto.ts`
    - `dtos/update-{{project.domain.Domain Object}}.dto.ts`
    - `{{project.domain.Domain Object}}.controller.test.ts`
    - `{{project.domain.Domain Object}}.service.test.ts`
    - `dtos/create-{{project.domain.Domain Object}}.dto.test.ts`
    - `dtos/update-{{project.domain.Domain Object}}.dto.test.ts`
    - (if needed) `{{project.domain.Domain Object}}.module.ts` updates
- New end-to-end test at `project_root/api/test/{{project.domain.Domain Object}}s.e2e-spec.ts`
- New .http test at `project_root/api/e2e/{{project.domain.Domain Object}}s.http`
- Documentation update in `project_root/api/README.md`  
- Documentation update in `project_rootREADME.md`  