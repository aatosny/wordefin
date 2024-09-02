#!/bin/bash

find_lst=$(find $HOME/Wordefin -name '*.md' -o -name '*.txt' -o -name '*.lst')
lsts_c=$(echo "$find_lst" | wc -l)

case $lsts_c in
	0)
		echo "Error: $HOME/Wordefin/: No wordlist found. See wordefin -h"
		exit
		;;
	[1-9])
		for i in {1..9}; do
			eval file$i=$(echo "$find_lst" | sed -n "${i}p")
		done
		;;
	*)
		echo "Error: Too many wordlists. Maximum amount is 9."
		exit
		;;
esac


for f in {1..9}; do
	eval file=\$file$f

	if [[ -n "$file" && -f "$file" ]]; then
    	while IFS= read -r l1 && IFS= read -r l2; do
      		echo "$l1 -- $l2"
    	done < <(cat "$file" | tr -d '\r' | awk NF)
    fi
done

