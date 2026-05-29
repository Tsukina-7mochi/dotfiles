#!/bin/bash

MESSAGE="Checking for package updates..."
ANIM_FRAMES=( '—' "\\" '|' '/' )
INDEX=0

echo -n "${MESSAGE} "

# Disable cursor blink
tput civis
trap "tput cnorm" EXIT

if [ -x "$(command -v brew)" ]; then
    printf "\n$(brew outdated -q | wc -l) updates available." &
else
    printf "\n$(checkupdates | wc -l) updates available." &
fi

pid="$!"
# if this script is killed, kill the checkupdates
trap "kill $pid 2> /dev/null" EXIT

while kill -0 $pid 2> /dev/null; do
    printf "%s\b" "${ANIM_FRAMES[INDEX]}"
    INDEX=$(( ($INDEX + 1) % ${#ANIM_FRAMES[@]} ))
    sleep 0.25
done

printf " \b\n"
