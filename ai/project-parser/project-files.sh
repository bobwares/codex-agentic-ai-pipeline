#!/bin/bash
#
# Combined Project Compilation Script
# @application Project Documentation Builder
# @source ./combine-project-docs.sh
# @author bobwares codebot
# @version 1.4
# @description Executes multiple content-generating scripts, collects their outputs,
#              and appends additional project metadata into a single markdown file.
#              Redacts sensitive environment values from final output.
# @exports
# - output/project.md
# @updated 2025-05-19

# Paths to helper scripts
CONFIG_SCRIPT="./config-files.sh"
SOURCE_SCRIPT="./source-code.sh"
IAC_SCRIPT="./iac-files.sh"

# Paths to metadata files
PROMPT_INSTRUCTIONS="./about/prompt-instructions.md"
PROJECT_ABOUT="./about/project-about.md"
VERSION_INFO="./about/version.md"
TECH_STACK="./about/tech-stack.md"

# Ensure output directory exists
mkdir -p output

# Combined output file
COMBINED_FILE="output/project.md"

# 1. Execute the helper scripts
bash "$CONFIG_SCRIPT"
bash "$SOURCE_SCRIPT"
bash "$IAC_SCRIPT"

# 3. Append prompt-instructions.md
if [ -f "$PROMPT_INSTRUCTIONS" ]; then

    cat "$PROMPT_INSTRUCTIONS" >> "$COMBINED_FILE"
else
    echo "Warning: $PROMPT_INSTRUCTIONS not found." >&2
fi

# 4. Append project-about.md
if [ -f "$PROJECT_ABOUT" ]; then
    echo "" >> "$COMBINED_FILE"
    echo "## About This Project" >> "$COMBINED_FILE"
    echo "" >> "$COMBINED_FILE"
    cat "$PROJECT_ABOUT" >> "$COMBINED_FILE"
else
    echo "Warning: $PROJECT_ABOUT not found." >&2
fi

# 5. Append version.md
if [ -f "$VERSION_INFO" ]; then
      echo "" >> "$COMBINED_FILE"
    cat "$VERSION_INFO" >> "$COMBINED_FILE"
else
    echo "Warning: $VERSION_INFO not found." >&2
fi

# 6. Append tech-stack.md
if [ -f "$TECH_STACK" ]; then
    echo "" >> "$COMBINED_FILE"
    cat "$TECH_STACK" >> "$COMBINED_FILE"
else
    echo "Warning: $TECH_STACK not found." >&2
fi

# 7. Append generated outputs in output/
for file in config-files.md source-code.md unit-test-files.md iac-report.md; do
    if [ -f "output/$file" ]; then
        echo "" >> "$COMBINED_FILE"
        cat "output/$file" >> "$COMBINED_FILE"
    else
        echo "Warning: output/$file not found." >&2
    fi
done

# 8. Sanitize sensitive environment variables
sed -i '' \
    -e 's/\(OPENAI_API_KEY\s*=\s*\).*/\1<REDACTED>/g' \
    -e 's/\(API_KEY\s*=\s*\).*/\1<REDACTED>/g' \
    -e 's/\(SECRET_KEY\s*=\s*\).*/\1<REDACTED>/g' \
    -e 's/\(ACCESS_TOKEN\s*=\s*\).*/\1<REDACTED>/g' \
    "$COMBINED_FILE"

# 9. Done
echo "Combined project compilation complete. See $COMBINED_FILE (sensitive values redacted)."
