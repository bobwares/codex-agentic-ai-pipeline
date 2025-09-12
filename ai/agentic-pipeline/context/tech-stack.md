Here’s the updated tech stack specification you requested:

**Tech Stack Update**

* **Language & Runtime**: Java 21 (LTS)
* **Framework**: Spring Boot 3.5.5
* **Database**: PostgreSQL (latest stable release recommended, e.g., 16.x)
* **Containerization**: Docker for local development and deployment
* **Build Tool**: Maven 
* **Testing**: JUnit 5, Testcontainers (for PostgreSQL integration tests inside Docker)

**Notes and Best Practices**

1. **Spring Boot 3.5.5 with Java 21**

  * Spring 3.5+ is fully compatible with Java 21.
  * Ensure Maven/Gradle compiler plugin is set to `--release 21`.

2. **Postgres with Docker**

  * Use the official Docker image:
    `docker run --name mydb -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres:16`
  * For dev/test pipelines, Testcontainers provides isolated PostgreSQL instances.

3. **Integration Setup**

  * `application.yml` should point to `jdbc:postgresql://localhost:5432/mydb` for dev.
  * Use environment variables or Spring Profiles for production-ready DB configs.

4. **Maven Dependencies (example)**

   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-jpa</artifactId>
   </dependency>
   <dependency>
       <groupId>org.postgresql</groupId>
       <artifactId>postgresql</artifactId>
       <scope>runtime</scope>
   </dependency>
   <dependency>
       <groupId>org.testcontainers</groupId>
       <artifactId>postgresql</artifactId>
       <scope>test</scope>
   </dependency>
   ```

5. **Docker Compose Option**

  * For multi-service setups, create a `docker-compose.yml` with `postgres` and your `spring-boot-app` as services.
