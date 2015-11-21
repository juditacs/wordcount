#!/usr/bin/env bash

run_command=$@

pass=1

echo
echo "---- $run_command ----"

for test_in in $( ls data/test/*in); do 
    test_out=${test_in%.in}.out
    output=$(diff <(cat $test_in | eval $run_command ) $test_out | wc -l)
    if [ $output -ne 0 ]; then
        fn=${test_in##*/}
        fn=${fn%.in}
        echo "  ${fn} fails"
        pass=0
    fi
done

if [ $pass -eq 1 ]; then
    echo "OK"
else
    echo "FAIL"
fi
