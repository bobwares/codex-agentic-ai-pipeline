#!/bin/bash

# generate-structure.sh - Version 2.1
# Generates a JSON-formatted document from the ../ root directory named directory-structure.json

OUTPUT_FILE="directory-structure.json"
ROOT="../"
SKIP_DIR="\.terraform|\.git|node_modules|\.idea|\.serverless|\.js\.map"

# Temporary file for intermediate results
temp_file=$(mktemp)

# Start JSON array
echo "[" > "$OUTPUT_FILE"

# Find all files, exclude unwanted directories, and create JSON objects
find "$ROOT" -type f | grep -Ev "$SKIP_DIR" | while read -r file; do
    RELATIVE_PATH=$(dirname "${file#$ROOT}")
    FILE_NAME=$(basename "$file")

    if [[ "$FILE_NAME" == "tsconfig.json" ]]; then
        FILE_TYPE="typescript config"
    elif [[ "$FILE_NAME" == "serverless.yml" ]]; then
        FILE_TYPE="serverless configuration"
    elif [[ "$FILE_NAME" == *.test.ts ]]; then
        FILE_TYPE="unit test"
    elif [[ "$FILE_NAME" == *.sh ]]; then
        FILE_TYPE="shell script"
    elif [[ "$FILE_NAME" == *.md ]]; then
        FILE_TYPE="markdown"
    else
        FILE_TYPE="${FILE_NAME##*.}"
    fi

    echo "  {\"path\": \"$(dirname "${file#$ROOT}")\", \"file\": \"$FILE_NAME\", \"type\": \"$FILE_TYPE\"}," >> "$temp_file"
done

# Remove trailing comma from last JSON element and close JSON array
sed '$ s/,$//' "$temp_file" >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

# Clean up temporary file
rm "$temp_file"

# Completion message
echo "Directory structure generated successfully. Check $OUTPUT_FILE."
