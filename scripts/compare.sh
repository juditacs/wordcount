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

workdir=`mktemp -d`
cat $data > $workdir/input
wc -l $workdir/input

for i in $( seq 1 $n); do
    cat run_commands.txt | while read line; do
    echo $line
    cat $workdir/input | eval /usr/bin/time -f "%e__%U__%M" -o $workdir/stat $line > $workdir/out
    wcl=$(wc -l $workdir/out | cut -f1 -d" ")
    if [ $wcl -ne 0 ]; then
        echo ${line}__$(cat $workdir/stat) | sed 's/__/\t/g' >> results.txt
    fi
done
    done

rm -r $workdir
