#!/bin/bash
set -e

# ---------------------------
# Inputs
# ---------------------------
YAML_PATH="$1"
JSON_PATH="$2"
GIT_USERNAME="$3"
GIT_EMAIL="$4"
COMMIT_MESSAGE="${5:-Update JSON from YAML}"

# ---------------------------
# Install swagger-cli
# ---------------------------
echo "Installing swagger-cli..."
npm install -g swagger-cli

# ---------------------------
# Convert YAML to JSON
# ---------------------------
echo "Converting YAML ($YAML_PATH) to JSON ($JSON_PATH)..."
swagger-cli bundle "$YAML_PATH" -o "$JSON_PATH" -t json

# ---------------------------
# Commit & Push Changes
# ---------------------------
echo "Configuring Git..."
git config user.name "$GIT_USERNAME"
git config user.email "$GIT_EMAIL"

git add "$JSON_PATH"

if ! git diff-index --quiet HEAD; then
    echo "Changes detected. Committing..."
    git commit -m "$COMMIT_MESSAGE"
    git push
else
    echo "No changes detected. Skipping commit."
fi
