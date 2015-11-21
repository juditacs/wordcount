#!/usr/bin/env bash
cat run_commands.txt | while read line; do bash test.sh $line; done
