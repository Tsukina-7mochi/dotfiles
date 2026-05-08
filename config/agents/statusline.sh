#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
GIT_BRANCH=$(git symbolic-ref --short HEAD)

echo "[$MODEL] ${CONTEXT}% / $GIT_BRANCH"
