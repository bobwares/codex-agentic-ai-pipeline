# Governance


## Coding Standards

### Metadata Header

— Every source, test, and IAC file in the target project must begin with Metadata Header comment section.
- exclude pom.xml
- Placement: Top of file, above any import or code statements.
- Version: Increment only when the file contents change.
- Date: UTC timestamp of the most recent change.


#### Metadata Header Template
    ```markdown
      /**
      * App: {{Application Name}}
      * Package: {{package}}
      * File: {{file name}}
      * Version: semantic versioning starting at 0.1.0
      * Turns: append {{turn number}} list when created or updated.
      * Author: {{author}}
      * Date: {{YYYY-MM-DDThh:mm:ssZ}}
      * Exports: {{ exported functions, types, and variables.}}
      * Description: documentate the function of the class or function. Document each
      *              method or function in the file.
      */
    ````

#### Source Versioning Rules

      * Use **semantic versioning** (`MAJOR.MINOR.PATCH`).
      * Start at **0.1.0**; update only when code or configuration changes.
      * Update the version in the source file if it is updated during a turn.

