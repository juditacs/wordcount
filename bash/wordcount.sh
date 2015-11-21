#!/usr/bin/env bash
sed 's/ /\n/g' | grep -v ^$ | sort | uniq -c | sed 's/^\s*//' | sort  -k1,2nr -k2 | awk 'BEGIN{OFS="\t"}{print $2,$1}'
