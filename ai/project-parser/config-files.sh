#!/bin/bash
# config-files.sh - Version 2.8
# Categorizes and compiles configuration files by implementation area into a single markdown file.
# Outputs to ./output/config-files.md
# Compatible with macOS Bash 3.2 (no name-reference usage)
# Redacts sensitive .env values in the final output.

set -e

OUTPUT_DIR="./output"
OUTPUT_FILE="$OUTPUT_DIR/config-files.md"
ROOT_DIR=".."

mkdir -p "$OUTPUT_DIR"
echo "# Configuration Files Compilation" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Config files categorized by implementation

JS_TS_CONFIG_FILES=(
  ".eslintrc.js"
  ".prettierrc"
  "package.json"
  "tsconfig.json"
  "tsconfig.build.json"
  "jest.config.ts"
  "nest-cli.json"
)

PYTHON_CONFIG_FILES=(
  "pyproject.toml"
  "requirements.txt"
  "tox.ini"
  ".pylintrc"
)

JAVA_CONFIG_FILES=(
  "pom.xml"
  "maven-wrapper.properties"
  "build.gradle"
  "settings.gradle"
  "application.properties"
  "application.yml"
)

DEVOPS_CONFIG_FILES=(
  "Dockerfile"
  "serverless.yml"
  ".env"
)

MISC_CONFIG_FILES=(
  ".gitignore"
)

CONFIG_SECTIONS=(
  "JavaScript / TypeScript:JS_TS_CONFIG_FILES"
  "Python:PYTHON_CONFIG_FILES"
  "Java:JAVA_CONFIG_FILES"
  "DevOps / Infrastructure:DEVOPS_CONFIG_FILES"
  "Miscellaneous:MISC_CONFIG_FILES"
)

# Directories to exclude
EXCLUDE_DIRS=(
  ".git"
  ".venv"
  "__pycache__"
  "node_modules"
  ".mypy_cache"
  ".pytest_cache"
  "dist"
  "build"
  "output"
  ".tox"
  ".idea"
  ".github"
)

# Build array-based prune expression
PRUNE_EXPR=()
for dir in "${EXCLUDE_DIRS[@]}"; do
  PRUNE_EXPR+=( -path "$ROOT_DIR/$dir" -prune -o )
done

# Function to render a single section only if files exist
render_section() {
  label="$1"
  varname="$2"
  eval "files=(\"\${${varname}[@]}\")"

  matched=()
  for filename in "${files[@]}"; do
    path=$(find "$ROOT_DIR" "${PRUNE_EXPR[@]}" -type f -name "$filename" -print | head -n 1)
    if [ -n "$path" ]; then
      matched+=("$path")
    fi
  done

  if [ ${#matched[@]} -eq 0 ]; then
    return
  fi

  echo "## $label" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"

  for path in "${matched[@]}"; do
    relative="./${path#../}"
    echo "### File: $relative" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    filename="${path##*/}"
    case "$filename" in
      *.json)       lang="json" ;;
      *.ts)         lang="typescript" ;;
      *.js)         lang="javascript" ;;
      *.yml|*.yaml) lang="yaml" ;;
      *.env)        lang="dotenv" ;;
      Dockerfile)   lang="docker" ;;
      *.xml)        lang="xml" ;;
      *.properties) lang="ini" ;;
      *.gradle)     lang="groovy" ;;
      *.toml)       lang="toml" ;;
      *.ini)        lang="ini" ;;
      *)            lang="bash" ;;
    esac

    echo "\`\`\`$lang" >> "$OUTPUT_FILE"
    cat "$path" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "\`\`\`" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done
}

# Generate each section
for entry in "${CONFIG_SECTIONS[@]}"; do
  label="${entry%%:*}"
  varname="${entry##*:}"
  render_section "$label" "$varname"
done

# Redact sensitive environment values
LC_CTYPE=C sed -i '' \
  -e 's/^\(OPENAI_API_KEY[[:space:]]*=[[:space:]]*\).*/\1<REDACTED>/g' \
  -e 's/^\(API_KEY[[:space:]]*=[[:space:]]*\).*/\1<REDACTED>/g' \
  -e 's/^\(SECRET_KEY[[:space:]]*=[[:space:]]*\).*/\1<REDACTED>/g' \
  -e 's/^\(ACCESS_TOKEN[[:space:]]*=[[:space:]]*\).*/\1<REDACTED>/g' \
  "$OUTPUT_FILE"

echo "Compilation complete. Markdown file written to: $OUTPUT_FILE (sensitive values redacted)"
