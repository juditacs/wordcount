#!/usr/bin/env bash
export LC_COLLATE=C
gawk '
function cmp(word1,count1,word2,count2) { 
  return (count1!=count2) ? (count2-count1) : (ord[substr(word1, 1, 1)]-ord[substr(word2, 1, 1)]) } 
BEGIN {
  OFS="\t"
  for(n=0;n<256;n++) ord[sprintf("%c",n)]=n
} 
{
  for(i=1;i<=NF;i++) a[$i]++
} 
END {
   PROCINFO["sorted_in"]="cmp"; 
   for(k in a) print k,a[k]
}'
