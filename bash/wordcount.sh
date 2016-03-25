#!/usr/bin/env bash
export LC_COLLATE=C
gawk '{for(i=1;i<=NF;i++) a[$i]++} END {PROCINFO["sorted_in"] = "@val_num_desc"; for(k in a) print k,"\t",a[k]}'
