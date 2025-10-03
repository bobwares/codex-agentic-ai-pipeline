## About

App Name: Streamlit App


## Technology Stack: Python Streamlit Application

* **Development Language**

  * Python 3.13

* **Frontend/UI**

  * Streamlit

* **Dependency Management**

  * requirements.txt

* **Configuration & Environment Management**

  * python-dotenv
  * configparser
  * pydantic

* **Testing**

  * pytest
  * streamlit.testing

* **CI/CD & Deployment**

  * GitHub Actions

* **Linting & Formatting**

  * Black
  * isort
  * flake8
  * Ruff

* **Logging & Observability**

  * logging
  * Loguru
  * Sentry

* **Recommended Directory Structure**

  * `src/`
  * `src/app.py`
  * `src/components/`
  * `src/services/`
  * `src/utils/`
  * `tests/`
  * `requirements.txt`
  * `.env`
  * `README.md`
  * `.gitignore`

## IDE

IntelliJ IDEA 2023.3.2 (Ultimate Edition)
Build #IU-233.13135.103, built on December 19, 2023
Runtime version: 17.0.9+7-b1087.9 x86_64
VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.
macOS 14.5
GC: G1 Young Generation, G1 Old Generation
Memory: 8192M
Cores: 12
Metal Rendering is ON
Registry:
  debugger.new.tool.window.layout=true
  ide.experimental.ui=true
Non-Bundled Plugins:
  com.jetbrains.plugins.ini4idea (233.13135.116)
  color.scheme.PyDarcula (1.1)
  org.intellij.plugins.hcl (233.13135.65)
  name.kropp.intellij.makefile (233.13135.65)
  Show As ... (1.0.3)
  com.github.dinbtechit.jetbrainsnestjs (0.0.2)
  org.asciidoctor.intellij.asciidoc (0.41.2)
  Pythonid (233.13135.103)
  net.ashald.envfile (3.4.1)
  com.koxudaxi.pydantic (0.4.14)
  intellij.jupyter (233.13135.103)
  aws.toolkit (2.2-233)
  dev.nx.console (1.32.4)
Kotlin: 233.13135.103-IJ


## AI Prompt Context Instructions

- Always include metadata header section for project at the top of each source code and configuration file.
- Definition of Metadata header section:

      ```markdown
      # App: {{App Name}}
      # Package: {{package}}
      # File: {{file name}}
      # Version: 0.0.1
      # Author: Bobwares
      # Date: {{current date/ time}}
      # Description: document the function of the code.
      #
      ```

### version.md
- create file version.md with updated version number and list of changes. Include date and time of change and branch name.
- start version at 0.0.1
  - Update version each time the code is updated.
  - Update only code or configuration files that have changed.

### Coding Rules
- Follow PEP 8 code formatting standards:
  - Python: PEP 8: E302 two blank lines before top-level definitions
  - Python: PEP 8: E303 too many blank lines (2)

### Tests

- Always generate unit tests
- Always include integration tests when appropriate.
- create .http tests under directory project_root/e2e

### Implementation
- Follow best practices.
- Use the latest versions of libraries.
- Include logging in source code.
- source code in directory project_root/src

End of File