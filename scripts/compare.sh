#!/usr/bin/env bash

if [ -z $1 ]; then
    echo "Usage: compare.sh [input file] [testnum=3]"
    exit
fi

data=$1

if [ -z $2 ]; then
	n=3
else
	n=$2
fi

if [[ "$data" == *gz ]]; then
    command=zcat
else
    command=cat
fi

cat run_commands.txt | while read line; do
    echo $line
    for i in $( seq 1 $n); do
        $command $data | eval /usr/bin/time -f "%e__%U__%M" $line > out 2>stat
        echo ${line}__$(cat stat) | sed 's/__/\t/g' >> results.txt
    done
done
