#!/bin/zsh

if git_status=$(cd $1 && git status 2>/dev/null ); then
  git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
  git_info="#[underscore]#[fg=colour105] ⭠ ${git_branch} #[default]${state}"
else
  git_info=""
fi

directory="#[underscore]#[fg=white]$1#[default]"

echo "$directory$git_info"
