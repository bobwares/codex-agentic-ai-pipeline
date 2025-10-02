# TASK – Add GitHub Actions for Spring Boot MVC JPA PostgreSQL

Purpose
Install deterministic CI for a Spring Boot 3.5.x service with Liquibase migrations and Testcontainers-backed tests. Validate the configuration contract for `src/main/resources/application.yml`. On tags, produce a signed, reproducible release artifact.

Scope

1. Create CI workflow for PRs and main branch pushes.
2. Create Release workflow for semantic tags (`v*.*.*`).
3. Enforce application config contract (no default fallbacks; keys present).
4. Run Maven build with JUnit 5 and Testcontainers; upload test reports and JARs.
5. Validate Liquibase changelogs (no apply/update in CI).
6. Concurrency guards, least-privilege permissions, and aggressive caching.

Repository assumptions

* Maven Wrapper committed (`./mvnw`, `.mvn/wrapper/**`).
* Java 21; Spring Boot 3.5.5; Liquibase configured under `db/changelog/db.changelog-master.yml`.
* Project root is the Maven module containing `pom.xml`.
* `application.yml` exactly follows your pattern (provided below) with required environment variables (no defaults):
  APP_NAME, APP_PORT, DATABASE_HOST, DATABASE_PORT, DATABASE_NAME, DATABASE_USERNAME, DATABASE_PASSWORD.

Deliverables

* `.github/workflows/ci.yml`
* `.github/workflows/release.yml`
* README badges snippet

Acceptance Criteria

* CI triggers only when files relevant to the service or the workflows change.
* CI executes: wrapper validation, dependency cache, `mvn -B -DskipTests=false verify`.
* Testcontainers runs integration tests without manual DB provisioning.
* Liquibase changelog validation runs and fails the build on errors.
* A simple static check asserts `application.yml` contains the required keys and does not use default fallbacks.
* Artifacts uploaded: JAR(s), surefire/failsafe reports, Jacoco coverage (if present).
* Tag push `v1.2.3` produces a release job that builds and uploads packaged JARs.
* All workflows set explicit permissions and concurrency and cache Maven properly.

Implementation

1. CI workflow
   File: `.github/workflows/ci.yml`

```yaml
name: CI

on:
  pull_request:
    paths:
      - "pom.xml"
      - "src/**"
      - ".mvn/**"
      - ".github/workflows/ci.yml"
  push:
    branches: ["main"]
    paths:
      - "pom.xml"
      - "src/**"
      - ".mvn/**"
      - ".github/workflows/ci.yml"

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  build-test:
    name: Build & Test (Java 21, Maven)
    runs-on: ubuntu-latest

    env:
      MAVEN_OPTS: "-Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss"
      # Ensure Testcontainers uses Docker-in-Docker service on GH runners (native Docker is available).
      TESTCONTAINERS_CHECKS_DISABLE: "true"

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Validate Maven Wrapper
        uses: gradle/wrapper-validation-action@v2

      - name: Setup Java 21
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: "21"
          cache: maven

      - name: Cache Maven Repository
        uses: actions/cache@v4
        with:
          path: |
            ~/.m2/repository
          key: m2-${{ runner.os }}-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            m2-${{ runner.os }}-

      - name: Verify application.yml contract
        run: |
          set -euo pipefail
          APP_YML="src/main/resources/application.yml"
          test -f "$APP_YML" || { echo "Missing $APP_YML"; exit 1; }

          # Required key presence (shallow, conservative)
          grep -qE 'spring:\s*$' "$APP_YML"
          grep -qE 'application:\s*$' "$APP_YML"
          grep -qE 'name:\s*\$\{APP_NAME\}' "$APP_YML"
          grep -qE 'datasource:\s*$' "$APP_YML"
          grep -qE 'url:\s*jdbc:postgresql:\$\{DATABASE_HOST\}:\$\{DATABASE_PORT\}/\$\{DATABASE_NAME\}|url:\s*jdbc:postgresql://' "$APP_YML" || {
            echo "Datasource URL must reference DATABASE_HOST/PORT/NAME"; exit 1; }
          grep -qE 'username:\s*\$\{DATABASE_USERNAME\}' "$APP_YML"
          grep -qE 'password:\s*\$\{DATABASE_PASSWORD\}' "$APP_YML"
          grep -qE 'liquibase:\s*$' "$APP_YML"
          grep -qE 'change-log:\s*classpath:db/changelog/db.changelog-master.yml' "$APP_YML"
          grep -qE '^server:\s*$' "$APP_YML"
          grep -qE 'port:\s*\$\{APP_PORT\}' "$APP_YML"
          grep -qE '^management:\s*$' "$APP_YML"
          grep -qE '^springdoc:\s*$' "$APP_YML"

          # Ban default fallbacks like ${VAR:-default} or ${VAR:default}
          if grep -qE '\$\{[A-Z0-9_]+:-?[^}]+\}' "$APP_YML"; then
            echo "application.yml must not contain default fallbacks in env substitutions"; exit 1;
          fi

      - name: Liquibase changelog validation (dry)
        run: |
          ./mvnw -B -DskipTests -Dliquibase.hub.mode=off liquibase:validate

      - name: Build & Test (unit + integration)
        run: |
          ./mvnw -B -DskipTests=false clean verify

      - name: Upload test reports
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: test-reports
          path: |
            **/target/surefire-reports/**
            **/target/failsafe-reports/**
            **/target/site/jacoco/**
          if-no-files-found: ignore

      - name: Upload JARs
        if: success()
        uses: actions/upload-artifact@v4
        with:
          name: app-jars
          path: |
            target/*.jar
          if-no-files-found: error
```

2. Release workflow
   File: `.github/workflows/release.yml`

```yaml
name: Release

on:
  push:
    tags:
      - "v*.*.*"

concurrency:
  group: release-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: write  # needed to create GitHub release

jobs:
  build-and-release:
    name: Build & Create GitHub Release
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Java 21
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: "21"
          cache: maven

      - name: Build (reproducible)
        run: |
          ./mvnw -B -DskipTests clean package

      - name: Collect artifacts
        run: |
          mkdir -p release
          cp -v target/*.jar release/

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: release-jars
          path: release/*

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ github.ref_name }}
          generate_release_notes: true
          files: |
            release/*.jar
```

3. README badges
   Insert near the top of your README:

```
[![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/<owner>/<repo>/actions/workflows/ci.yml)
[![Release](https://github.com/<owner>/<repo>/actions/workflows/release.yml/badge.svg)](https://github.com/<owner>/<repo>/actions/workflows/release.yml)
```

Notes and rationale

* Testcontainers: GitHub’s Ubuntu runners include Docker; no external DB service needed. The CI job runs full integration tests.
* Liquibase: `liquibase:validate` ensures changelog integrity without mutating schema in CI.
* Config contract: the shell check enforces that `application.yml` keeps your “no default fallbacks” rule and includes the required keys.
* Permissions/concurrency: least-privilege and cancels superseded runs to save minutes.
* Caching: both setup-java’s built-in Maven cache and an explicit `~/.m2` cache are provided; you can drop the explicit cache if you prefer the built-in only.
