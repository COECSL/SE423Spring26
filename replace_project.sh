#!/bin/bash
set -euo pipefail

# === Config ===
SOURCE_FILE=".project_rel"
TARGET_FILE=".project"
TMP_FILE="${TARGET_FILE}.tmp"
TOKEN="PARENT-2-PROJECT_LOC"

# === Compute absolute path two levels up ===
REPLACEMENT="$(cd ../../ && pwd)"

# === Convert backslashes to forward slashes (if any) ===
REPLACEMENT="${REPLACEMENT//\\//}"

# === Copy source to temp file ===
cp "$SOURCE_FILE" "$TMP_FILE"

# === Detect OS for sed in-place syntax ===
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS / BSD sed requires empty string for in-place edit
    sed -i '' "s|$TOKEN|$REPLACEMENT|g" "$TMP_FILE"
else
    # Linux / GNU sed
    sed -i "s|$TOKEN|$REPLACEMENT|g" "$TMP_FILE"
fi

# === Replace target file ===
mv -f "$TMP_FILE" "$TARGET_FILE"

echo "File replaced successfully."
