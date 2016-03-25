#!/usr/bin/env bash

if [ -z $4 ]; then
    echo "Usage: run_one.sh [input file] [testnum=3] [command] [comment]"
    exit
fi

data=$1

if [ -z $2 ]; then
	n=3
else
	n=$2
fi

to_run=$3

comment=$4

workdir=`mktemp -d`
cat $data > $workdir/input

for i in $( seq 1 $n); do
    cat $workdir/input | eval /usr/bin/time -f "%e__%U__%M" -o $workdir/stat $to_run > $workdir/out
    wcl=$(wc -l $workdir/out | cut -f1 -d" ")
    if [ $wcl -ne 0 ]; then
        echo ${to_run}__$(cat $workdir/stat)__${comment} | sed 's/__/\t/g'
    fi
    done

rm -r $workdir
