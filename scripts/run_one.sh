#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
    echo "Usage: run_one.sh input file command [comment] [testnum=1]"
    exit
fi

data=$1

to_run=$2

comment=$3

if [ -z $4 ]; then
	n=1
else
	n=$4
fi

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
