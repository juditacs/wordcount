#!/usr/bin/env bash
export LC_COLLATE=C
tr '\t ' '\n\n' | grep -v ^$ | awk '{x[$0]++} END {for (w in x) {print x[w], w}}' | sort -k1,2nr -k2 | awk 'BEGIN{OFS="\t"}{print $2,$1}'
