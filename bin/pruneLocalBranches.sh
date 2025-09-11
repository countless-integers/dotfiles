#!/usr/bin/env bash

git fetch -ap &>/dev/null

git branch -vv | grep ": gone]" | awk '{ print $1 }'

read -p "Delete those? [Y|n]: " answer
if [[ "$answer" == "n" ]]; then
  echo "Aborted by user"
  exit 1
fi

read -p "Use force? [Y|n]" answer
if [[ "$answer" == "n" ]]; then
  git branch -vv | grep ": gone]" | awk '{ print $1 }' | xargs -n 1 git branch -d
  exit 0
fi
git branch -vv | grep ": gone]" | awk '{ print $1 }' | xargs -n 1 git branch -D
