#!/usr/bin/env bash
export LC_COLLATE=C
export PHYS_CORES=$(cat /proc/cpuinfo | grep 'core id' | sort | uniq | wc -l)
sed -E 's/[\t ]+/\n/g' | grep -v ^$ | sort -S 40% --parallel $PHYS_CORES | uniq -c | sort -S 40% ---parallel $PHYS_CORES 2 -k1,2nr -k2 | awk 'BEGIN{OFS="\t"}{print $2,$1}'
