#!/usr/bin/env bash


if [ -z $1 ]; then
    echo "Usage: compare_full.sh [input file]"
    exit
fi

data=$1

if [[ "$data" == *gz ]]; then
    cat_command=zcat
else
    cat_command=cat
fi

workdir=`mktemp -d`
$cat_command $data > $workdir/input

cat $workdir/input | ./bash/wordcount.sh > $workdir/etalon

cat run_commands.txt | while read line; do
    cat $workdir/input | eval $line > $workdir/current
    hash_expected=$(md5sum $workdir/etalon | awk '{ print $1 }')
    hash_actual=$(md5sum $workdir/current | awk '{ print $1 }')
    if [ ${hash_actual} -ne ${hash_expected} ]; then
       echo "$line output differs from etalon"
    fi
done

rm -r $workdir
