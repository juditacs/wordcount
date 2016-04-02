#!/usr/bin/env bash
export LC_COLLATE=C
sed 's/[\t ]/\n/g' | grep -v ^$ | sort -S 40% | uniq -c | sed '/^\s*/d' | sort -S 40% -k1,2nr -k2 | awk 'BEGIN{OFS="\t"}{print $2,$1}'
