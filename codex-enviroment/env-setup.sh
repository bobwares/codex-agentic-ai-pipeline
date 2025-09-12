#!/usr/bin/env bash
# setup_repo.sh
# Copies the java-spring-boot-codex-starter repo into the Codex workspace.

set -euo pipefail

REPO_URL="https://github.com/bobwares/codex-agentic-ai-pipeline"
TARGET_DIR="codex-agentic-ai-pipeline"

cd ..
# If directory already exists, skip clone
if [ -d "$TARGET_DIR/.git" ]; then
  echo "Repository already cloned in $TARGET_DIR. Skipping..."
else
  echo "Cloning $REPO_URL into $TARGET_DIR..."
  git clone "$REPO_URL" "$TARGET_DIR"
fi

echo "Repository is ready in $TARGET_DIR."

ln -s /workspace/codex-agentic-ai-pipeline/AGENTS.md AGENTS.md

echo "Symlink created: AGENTS.md -> /workspace/codex-agentic-ai-pipeline/AGENTS.md"

