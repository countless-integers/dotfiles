#!/bin/bash
git fetch -ap &>/dev/null
git branch -vv | grep ": gone]" | awk '{ print $1 }'
read -p "Delete those? [y|n]" answer
if [ "$answer" == "y" ]; then

    read -p "Use force? [y|n]" answer
    if [ "$answer" == "y" ]; then
        git branch -vv | grep ": gone]" | awk '{ print $1 }' | xargs -n 1 git branch -D
    else
        git branch -vv | grep ": gone]" | awk '{ print $1 }' | xargs -n 1 git branch -d
    fi
fi
