
# Application Implementation Pattern: Spring Boot MVC JPA PostgreSQL

## Purpose

Build a production-grade REST API using Spring Boot MVC, Spring Data JPA, and PostgreSQL. Standardize schema evolution (liquidbase), docs (Springdoc), observability (Actuator), developer ergonomics (Lombok), testing (JUnit 5 + Testcontainers), and turn artifact aggregation.
use application.yml in the pattern defined below.

## Tech Stack

* Language/Runtime: Java 21
* Framework: Spring Boot 3.5.5
* Web: Spring MVC (spring-boot-starter-web)
* Persistence: Spring Data JPA
* Database: PostgreSQL 16.x
* Migrations: liquidbase
* API Docs: Springdoc OpenAPI (webmvc UI)
* Observability: Spring Boot Actuator
* Ergonomics: Lombok
* Testing: JUnit 5, Testcontainers (PostgreSQL)
* Build: Maven


## Configuration Files Produced 

### .gitignore

```
.env*
/ai/project-parser/output

.DS_Store
/ai/output
HELP.md
target/
.mvn/wrapper/maven-wrapper.jar
!**/src/main/**/target/
!**/src/test/**/target/

### STS ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr

### NetBeans ###
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/
build/
!**/src/main/**/build/
!**/src/test/**/build/

### VS Code ###
.vscode/
.DS_Store
**/.DS_Store

```

### application.yml 

Path: src/main/resources/application.yml

```yaml
spring:
  application:
    name: ${APP_NAME}

  datasource:
    url: jdbc:postgresql://${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_NAME}
    username: ${DATABASE_USERNAME}
    password: ${DATABASE_PASSWORD}
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        format_sql: true
        show_sql: false

  liquibase:
    change-log: classpath:db/changelog/db.changelog-master.yml
    enabled: true
    contexts: ${LIQUIBASE_CONTEXTS:}
    default-schema: ${DATABASE_SCHEMA:public}
    drop-first: false
    parameters:
      appName: ${APP_NAME}

server:
  port: ${APP_PORT}

management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      show-details: always
  health:
    db:
      enabled: true

springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html

```

Required environment variables (no defaults):
APP_NAME, APP_PORT, DATABASE_HOST, DATABASE_PORT, DATABASE_NAME, DATABASE_USERNAME, DATABASE_PASSWORD

