#!/bin/bash
echo -n "looking for files starting from current dir... \n"
find . -type f | cut -d/ -f 2 | uniq -c | sort -g
