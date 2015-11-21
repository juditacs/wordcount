#!/usr/bin/env bash

if [ -z $1 ]; then
	n=3
else
	n=$1
fi

cat run_commands.txt | while read line; do
    echo $line
    for i in {1..$n}; do
        zcat data/romanian_100k.gz | eval /usr/bin/time -f "%e__%U__%M" $line > out 2>stat
        echo ${line}__$(cat stat) | sed 's/__/\t/g' >> results.txt
    done
done
