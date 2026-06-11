#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
EFFORT=$(echo "$input" | jq -r '.effort.level')
CONTEXT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
FIVE_HOUR=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
SEVEN_DAY=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)
GIT_BRANCH=$(git symbolic-ref --short HEAD)

braille() {
  local p=$1
  local levels=("⡀" "⣀" "⣄" "⣤" "⣦" "⣶" "⣷" "⣿")
  local i=$(( p * 7 / 100 ))
  (( i > 7 )) && i=7
  (( i < 0 )) && i=0
  printf '%s' "${levels[$i]}"
}

printf "\033[38;5;209m[%s / %s effort]\033[0m " "$MODEL" "$EFFORT"
echo -n "$GIT_BRANCH / "
echo -n "ctx ${CONTEXT}% $(braille $CONTEXT) / "
echo -n "5h ${FIVE_HOUR}% $(braille $FIVE_HOUR) / "
echo "7d ${SEVEN_DAY}% $(braille $SEVEN_DAY)"
