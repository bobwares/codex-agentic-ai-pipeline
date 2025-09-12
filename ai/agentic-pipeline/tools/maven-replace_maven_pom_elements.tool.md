## Tool: Replace Maven POM Elements

### Purpose

Given a Maven POM XML, replace only the text nodes of `<groupId>`, `<artifactId>`, `<name>`, and `<description>` with values from the Codex session context. Preserve XML structure, indentation, and tags exactly as-is.

---

### Inputs

Load Codex session context.

---

### Example Run

**Provided Context:**

# Project

## Maven

- groupId: com.bobwares.customer
- artifactId: registration
- name: Customer Registration
- description: Spring Boot service for managing customer registrations


**Result:**

Response with update pom.xml with the following changes.


```xml
  <groupId>com.bobwares.customer</groupId>
  <artifactId>registration</artifactId>
  <name>Customer Registration</name>
  <description>Spring Boot service for managing customer registrations</description>
```
