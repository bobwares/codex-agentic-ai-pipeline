#!/usr/bin/env bash
set -euo pipefail

# Ensure custom bin directory is first in PATH
export PATH="$HOME/bin:$PATH"

###############################################################################
# Terraform                                                                 ###
###############################################################################
if ! command -v terraform >/dev/null 2>&1; then
  T_VERSION="1.8.5"
  TMP_DIR=$(mktemp -d)
  echo "Installing Terraform ${T_VERSION}"
  curl -fsSL -o "$TMP_DIR/terraform.zip" \
       "https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip"
  unzip -q "$TMP_DIR/terraform.zip" -d "$TMP_DIR"
  mkdir -p "$HOME/bin"
  install -m 0755 "$TMP_DIR/terraform" "$HOME/bin/terraform"
  rm -rf "$TMP_DIR"
fi

###############################################################################
# TFLint (Terraform linter)                                                 ###
###############################################################################
if ! command -v tflint >/dev/null 2>&1; then
  TFLINT_VERSION="v0.58.0"   # latest as of May 24 2025 :contentReference[oaicite:0]{index=0}
  OS="$(uname | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH" && exit 1 ;;
  esac

  TMP_DIR=$(mktemp -d)
  echo "Installing TFLint ${TFLINT_VERSION}"
  curl -fsSL -o "$TMP_DIR/tflint.zip" \
       "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_${OS}_${ARCH}.zip"
  unzip -q "$TMP_DIR/tflint.zip" -d "$TMP_DIR"
  mkdir -p "$HOME/bin"
  install -m 0755 "$TMP_DIR/tflint" "$HOME/bin/tflint"
  rm -rf "$TMP_DIR"
fi

echo "Setup complete."
