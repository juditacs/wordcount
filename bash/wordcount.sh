#!/usr/bin/env bash
export LC_COLLATE=C
sed 's/[\t ]/\n/g' | grep -v ^$ | sort | uniq -c | sed 's/^\s*//' | sort  -k1,2nr -k2 | awk 'BEGIN{OFS="\t"}{print $2,$1}'
