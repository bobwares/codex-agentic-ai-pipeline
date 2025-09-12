# Tool – Generate CRUD with OpenAPI, Unit Tests, and E2E HTTP (Spring MVC + JPA + Postgres)

## Role
You are an expert Java Spring Boot engineer. Implement synchronous CRUD endpoints for a domain object backed by **Spring Data JPA** on **PostgreSQL**. Produce code, tests, and an E2E `.http` file. Conform to repository metadata/versioning rules.

## Inputs
codex_session_context variables.

### Project
- Name, Detailed Description, Author

### Maven
- groupId
- artifactId
- name
- description

### Domain
- Domain Object (singular)
- Persisted Data schema (source of truth for fields, nullability, uniques, relationships)

## Objectives
1. Create a **Spring MVC** REST API in package `{{groupId}}.{{artifactId}}` for `{{Domain Object}}`.
2. Persist using **Spring Data JPA** mapped to PostgreSQL tables defined by the schema/DDLs.
3. Annotate endpoints with **springdoc OpenAPI**.
4. Validate input via **Jakarta Bean Validation**.
5. Provide **unit tests** (service/repository) and **integration tests** (controller) against a real Postgres (Testcontainers if available, else local profile).
6. Provide an `.http` file covering create → read → update → delete E2E.

## Non-functional Constraints
- Java 21, Spring Boot 3.5.x, **Spring MVC** (`spring-boot-starter-web`).
- Persistence with **JPA/Hibernate** (`spring-boot-starter-data-jpa`) + PostgreSQL driver.
- OpenAPI via `springdoc-openapi-starter-webmvc-ui`.
- Do not modify code under package `health`.
- Use `open-in-view: false`; service layer encapsulates transactions.
- Respect existing DDL/table/column names; no schema drift.

## Deliverables (create or update)
1) Domain + Persistence
- `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}.java`
  - `@Entity`, `@Table(name="<table_name>")`
  - Fields from schema with `@Column(name="...", nullable=..., length=...)`
  - Primary key: prefer `UUID` with `@Id`, `@GeneratedValue`, `@JdbcTypeCode(SqlTypes.UUID)`
  - Uniques via `@UniqueConstraint` or `unique = true`
  - FKs via `@ManyToOne`, `@OneToMany` only if indicated by schema

- `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Repository.java`
  - `interface {{Domain}}Repository extends JpaRepository<{{Domain}}, UUID>`
  - Convenience finders for unique fields (e.g., `findByEmail`)

- `src/main/java/{{groupIdPath}}/{{artifactId}}/{{Domain}}Service.java`
  - `@Service`, `@Transactional`
  - Methods: `create`, `get`, `list`, `update`, `delete`
  - Enforce uniqueness where schema requires (e.g., email)

2) API
- `src/main/java/{{groupIdPath}}/{{artifactId}}/api/{{Domain}}Dto.java`
  - `CreateRequest`, `UpdateRequest`, `Response` with bean validation

- `src/main/java/{{groupIdPath}}/{{artifactId}}/api/{{Domain}}Controller.java`
  - `@RestController`, `@RequestMapping("/api/{{Domain}}s")`
  - Methods: POST create(201), GET by id(200), GET list(200), PUT update(200), DELETE(204)

- OpenAPI annotations:
  - `@Tag`, `@Operation`, `@ApiResponses`, `@Parameter`, `@RequestBody`
  - Ensure models appear correctly in generated docs

3) Error Handling
- `src/main/java/{{groupIdPath}}/{{artifactId}}/web/RestExceptionHandler.java`
  - Map `EntityNotFoundException` → 404, `IllegalArgumentException`/validation → 400/422

4) Tests
- Unit: `src/test/java/.../{{Domain}}ServiceTests.java`
  - Create/get/update/delete happy paths; uniqueness violation

- Integration: `src/test/java/.../{{Domain}}ControllerIT.java`
  - `@SpringBootTest(webEnvironment=RANDOM_PORT)` + `@AutoConfigureMockMvc` or `@AutoConfigureWebTestClient`
  - Backed by **Testcontainers Postgres** if dependency present; else assume local profile env
  - Assert statuses/payloads; full CRUD flow

5) E2E HTTP
- `e2e/{{Domain}}.http`
  - POST → capture `id`
  - GET by `id`
  - PUT update
  - DELETE
  - GET (expect 404)

> `{{groupIdPath}}` = `{{groupId}}` with dots replaced by slashes.

## Implementation Details

### Mapping Rules
- JSON `string` → Java `String` (`@Size(max=n)` if `maxLength`)
- JSON `string(format: uuid)` → `UUID` + `@JdbcTypeCode(SqlTypes.UUID)`
- Required → `@NotNull`/`@NotBlank` and `nullable=false`
- `enum` → Java `enum` + `@Enumerated(EnumType.STRING)`
- Arrays needing tables → separate child entity only if present in DDL/schema

### OpenAPI
- Add `org.springdoc:springdoc-openapi-starter-webmvc-ui` to POM if missing.
- UI should be available at `/swagger-ui.html`.

### Testing Notes
- If `org.testcontainers:postgresql` is on classpath, use it:
  - Start container in a static initializer or `@TestConfiguration`
  - Expose JDBC URL/creds to Spring context
- Otherwise, require `application-local.yml` with env-driven creds and instruct to run tests with `-Dspring.profiles.active=local`.

## E2E HTTP File Requirements
- `@host = http://localhost:{{PORT:8080}}`
- JSON payloads reflect DTOs (snake_case to match API contract if used; otherwise standard camelCase)
- Sequence: POST → GET → PUT → DELETE → GET(404)

## Output Format
Provide only the files listed above, each with the standard metadata header. Do not include binaries.

## Acceptance Criteria
- Compiles on Java 21; Spring Boot 3.5.x.
- Entities, repository, and service align with existing DDL; no naming drift.
- CRUD endpoints pass integration tests (Testcontainers or local DB).
- OpenAPI renders models and endpoints accurately.
- `.http` scenario executes end-to-end successfully.
