#!/bin/bash 

git log  --pretty=oneline --all  --since="$1 days ago" | cut -c42-1000 | awk '!x[$0]++'
