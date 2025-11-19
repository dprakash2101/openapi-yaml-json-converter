#!/bin/bash
set -e

YAML_PATH="$1"
JSON_PATH="$2"
GIT_USERNAME="$3"
GIT_EMAIL="$4"
COMMIT_MESSAGE="${5:-Update JSON from YAML}"
TOKEN="$6"

# Fallback defaults
GIT_USERNAME="${GIT_USERNAME:-github-actions[bot]}"
GIT_EMAIL="${GIT_EMAIL:-github-actions[bot]@users.noreply.github.com}"

# Install swagger-cli
npm install -g swagger-cli

# Convert YAML to JSON
swagger-cli bundle "$YAML_PATH" -o "$JSON_PATH" -t json

# Configure Git
git config user.name "$GIT_USERNAME"
git config user.email "$GIT_EMAIL"

# Set remote URL using token
git remote set-url origin https://$TOKEN@github.com/${GITHUB_REPOSITORY}.git

# Commit and push if there are changes
git add "$JSON_PATH"
if ! git diff-index --quiet HEAD; then
    git commit -m "$COMMIT_MESSAGE"
    git push origin HEAD
else
    echo "No changes detected. Skipping commit."
fi
