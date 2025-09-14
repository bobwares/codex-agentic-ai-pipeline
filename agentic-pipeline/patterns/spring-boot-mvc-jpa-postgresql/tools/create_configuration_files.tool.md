# tool – Create Configuration Files

1. create the .gitignore defined in the codex_project_context.
2. create spring @ConfigurationProperties in config package. class AppProperties 
3. add configuration processor to pom.yml
    ```
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-configuration-processor</artifactId>
      <optional>true</optional>
    </dependency>
    ```
4. create local application.yml