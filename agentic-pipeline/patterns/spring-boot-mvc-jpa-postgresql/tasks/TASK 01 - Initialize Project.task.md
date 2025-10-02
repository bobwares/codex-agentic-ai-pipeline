# TASK 01 – Initialize Project

## Goal

Create a clean Spring Boot Java 21 project scaffold with exact `pom.xml`, baseline configuration (`application.yml` + validated `@ConfigurationProperties`), logging, testing, formatting (Spotless) and linting (Checkstyle), plus a minimal controller. Output builds, runs, and validates required environment/config on startup. Do not generate or commit the Maven Wrapper; provide instructions to add it later.

## Output (authoritative)

* pom.xml (exact content below)
* src/main/java/com/example/app/Application.java
* src/main/java/com/example/app/config/AppProperties.java
* src/main/java/com/example/app/web/MetaController.java
* src/main/resources/application.yml
* src/main/resources/application-example.yml
* src/test/java/com/example/app/ApplicationSmokeTest.java
* .editorconfig
* .gitignore (exact content below)
* checkstyle.xml (minimal Google-style baseline)
* .checkstyle-suppressions.xml
* .java-version (optional; set to 21)
* README-config.md (includes instructions to add Maven Wrapper yourself)




File: pom.xml


```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>{{project_context.maven.groupid}}</groupId>
  <artifactId>{{project_context.maven.artifactId}}</artifactId>
  <name>{{project_context.project.name}}</name>
  <description>{{project_context.project.short description}}</description>
  <packaging>jar</packaging>

  <properties>
    <java.version>21</java.version>
    <spring-boot.version>3.3.4</spring-boot.version>
    <springdoc.version>2.6.0</springdoc.version>
    <maven.compiler.release>${java.version}</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <checkstyle.version>10.17.0</checkstyle.version>
    <spotless.version>2.45.0</spotless.version>
  </properties>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>${spring-boot.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <!-- Web + Validation -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>

    <!-- Configuration metadata generation -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-configuration-processor</artifactId>
      <optional>true</optional>
    </dependency>
    <dependency>
      <groupId>org.liquibase</groupId>
      <artifactId>liquibase-core</artifactId>
    </dependency>
    <dependency>
      <groupId>org.postgresql</groupId>
      <artifactId>postgresql</artifactId>
    </dependency> 
    <!-- Actuator -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>

    <!-- OpenAPI UI -->
    <dependency>
      <groupId>org.springdoc</groupId>
      <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
      <version>${springdoc.version}</version>
    </dependency>

    <!-- Lombok (ergonomics) -->
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <optional>true</optional>
    </dependency>

    <!-- Test -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <!-- Spring Boot -->
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <configuration>
          <mainClass>com.example.app.Application</mainClass>
        </configuration>
      </plugin>

      <!-- Compiler -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.13.0</version>
        <configuration>
          <release>${maven.compiler.release}</release>
        </configuration>
      </plugin>

      <!-- Checkstyle -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-checkstyle-plugin</artifactId>
        <version>3.5.0</version>
        <configuration>
          <configLocation>checkstyle.xml</configLocation>
          <suppressionsLocation>.checkstyle-suppressions.xml</suppressionsLocation>
          <encoding>${project.build.sourceEncoding}</encoding>
          <consoleOutput>true</consoleOutput>
          <failOnViolation>true</failOnViolation>
        </configuration>
        <executions>
          <execution>
            <id>checkstyle-validate</id>
            <phase>validate</phase>
            <goals>
              <goal>check</goal>
            </goals>
          </execution>
        </executions>
      </plugin>

      <!-- Spotless (formatting) -->
      <plugin>
        <groupId>com.diffplug.spotless</groupId>
        <artifactId>spotless-maven-plugin</artifactId>
        <version>${spotless.version}</version>
        <configuration>
          <java>
            <eclipse />
            <removeUnusedImports />
            <formatAnnotations />
          </java>
        </configuration>
        <executions>
          <execution>
            <goals>
              <goal>apply</goal>
            </goals>
            <phase>process-sources</phase>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>

  <profiles>
    <profile>
      <id>local</id>
      <properties>
        <spring.profiles.active>local</spring.profiles.active>
      </properties>
    </profile>
  </profiles>
</project>
```

File: src/main/java/com/example/app/Application.java

```java
package com.example.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan("com.example.app.config")
public class Application {
  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }
}
```

File: src/main/java/com/example/app/config/AppProperties.java

```java
package com.example.app.config;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@Getter
@Setter
@Validated
@ConfigurationProperties(prefix = "app")
public class AppProperties {

  @NotBlank
  private String name = "backend";

  @NotNull
  @Min(1)
  @Max(65535)
  private Integer port = 8080;
}
```

File: src/main/java/com/example/app/web/MetaController.java

```java
package com.example.app.web;

import com.example.app.config.AppProperties;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/meta")
public class MetaController {

  private final AppProperties props;

  public MetaController(AppProperties props) {
    this.props = props;
  }

  @GetMapping("/env")
  public Map<String, Object> env() {
    return Map.of("app", props.getName(), "port", props.getPort());
  }
}
```

File: src/main/resources/application.yml

```yaml
spring:
  application:
    name: ${APP_NAME:backend}
  main:
    banner-mode: "console"
  output:
    ansi:
      enabled: DETECT

server:
  port: ${PORT:8080}

management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      show-details: when_authorized

app:
  name: ${APP_NAME:backend}
  port: ${PORT:8080}
```

File: src/main/resources/application.yml

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
    open-in-view: false
    properties:
      hibernate:
        format_sql: true
        jdbc.time_zone: UTC
  liquibase:
    change-log: classpath:db/changelog/db.changelog-master.yml
    enable: true
  main:
    allow-bean-definition-overriding: false
springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
server:
  port: ${APP_PORT}
management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      probes:
        enabled: true
  observations:
    key-values:
      application: ${APP_NAME}
app:
  name: ${APP_NAME}
  default-tax-rate: ${APP_DEFAULT_TAX_RATE}
  default-shipping-cost: ${APP_DEFAULT_SHIPPING_COST}
  supported-currencies: ${APP_SUPPORTED_CURRENCIES}

```

File: src/test/java/com/example/app/ApplicationSmokeTest.java

```java
package com.example.app;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ApplicationSmokeTest {

  @Test
  void contextLoads() {
  }
}
```


File: README-config.md

```
# Config usage

Validated configuration is provided via `AppProperties` (`@ConfigurationProperties(prefix = "app")`, `@Validated`).
Bind sources: environment variables (APP_NAME, PORT) or `application.yml`.

Endpoints
- GET /meta/env → returns current app name and port.
- OpenAPI UI at /swagger-ui.html; spec at /v3/api-docs.

Profiles
- Run with `-Dspring-boot.run.profiles=local` or export `SPRING_PROFILES_ACTIVE=local`.
- Use `application-local.yml` locally (copy from `application-example.yml`).

Build & Run (no Maven Wrapper in repo)
- Build: `mvn -q -DskipTests=false clean verify`
- Run:   `mvn spring-boot:run -Dspring-boot.run.profiles=local`

Add Maven Wrapper (optional, run locally; do not commit binaries via ChatGPT Codex)
- Generate wrapper files with your installed Maven:
  - `mvn -N wrapper:wrapper -Dmaven=3.9.9`
- This creates `mvnw`, `mvnw.cmd`, and `.mvn/wrapper/*` on your machine.
- After generating locally, you may commit these files from your workstation if your policy allows committing binaries.

Validation test
- Set an invalid `PORT` (e.g., `PORT=0`) and run. Startup should fail fast with a constraint violation referencing `AppProperties.port`.
```

File: ./e2e/actuator.http

Create .http file to call actuator endpoints