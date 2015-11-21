#!/usr/bin/env bash
cat run_commands.txt | while read line; do bash scripts/test.sh $line; done
