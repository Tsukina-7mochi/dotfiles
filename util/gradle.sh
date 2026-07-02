#!/bin/zsh

function gradle() {
  local gradlew_path=""

  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/gradlew" ]]; then
      gradlew_path="$dir/gradlew"
      break
    fi
    dir=$(dirname "$dir")
  done

  if [[ -n "$gradlew_path" ]]; then
    "$gradlew_path" "$@"
  else
    echo "error: no gradlew found in current or parent directories"
    return 1
  fi
}

function gradlew() {
    gradle "$@"
}
