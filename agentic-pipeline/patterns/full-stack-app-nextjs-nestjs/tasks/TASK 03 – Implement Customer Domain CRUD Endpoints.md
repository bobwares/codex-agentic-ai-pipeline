# Task 03 – Implement Customer Domain CRUD Endpoints

**Description**  
Based on the `customer_domain` JSON schema (`project_root/schemas/customer_domain.json`), implement a full set of RESTful CRUD endpoints in the backend API (`project_root/api`):

- **Controller**
    - Create `CustomerController` with routes:
        - `GET    /customers`        → list all customers
        - `GET    /customers/:id`    → fetch one customer by ID
        - `POST   /customers`        → create a new customer
        - `PUT    /customers/:id`    → update an existing customer
        - `DELETE /customers/:id`    → remove a customer
- **Service**
    - Implement `CustomerService` with methods: `create()`, `findAll()`, `findOne()`, `update()`, `remove()`.
- **DTOs & Validation**
    - Define `CreateCustomerDto` and `UpdateCustomerDto` matching the schema fields, with `class-validator` decorators.
- **Persistence**
    - Ensure the `Customer` entity (or model) defined under `libs/domain/` is registered in your ORM (TypeORM/Prisma) and wired into the API module.
- **Testing**
    - Add an end-to-end test suite in `project_root/api/test/customers.e2e-spec.ts` covering all CRUD routes.

**Acceptance Criteria**
- `project_root/api/src/customers/customer.controller.ts` contains all five CRUD routes.
- `CustomerService` and the two DTO classes exist and enforce schema validation.
- The persistence layer correctly maps to the JSON schema and is wired into `ApiModule`.
- `customers.e2e-spec.ts` tests for create, read (all & one), update, and delete operations all pass.
- `project_root/api/README.md` is updated with a “Customers API” section documenting each endpoint.
- A pull request is opened on branch `task-03-create-customer-crud-endpoints`.

**Inputs**
- `project_root/schemas/customer_domain.json` (Customer aggregate schema)

**Expected Outputs**
- New/updated files under `project_root/api/src/customers/`:
    - `customer.controller.ts`
    - `customer.service.ts`
    - `dtos/create-customer.dto.ts`
    - `dtos/update-customer.dto.ts`
    - `customer.controller.test.ts`
    - `customer.service.test.ts`
    - `dtos/create-customer.dto.test.ts`
    - `dtos/update-customer.dto.test.ts`
    - (if needed) `customer.module.ts` updates
- New end-to-end test at `project_root/api/test/customers.e2e-spec.ts`
- New .http test at `project_root/api/e2e/customers.http`
- Documentation update in `project_root/api/README.md`  
- Documentation update in `project_rootREADME.md`  