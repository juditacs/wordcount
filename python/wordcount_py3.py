#!/usr/bin/env python3
from collections import defaultdict
from itertools import groupby
from sys import stdin
from sys import stdout

def word_count():
    counter = defaultdict(int)
    for l in stdin.buffer:
        for word in l.split():
            counter[word] += 1

    groupedcounts = defaultdict(list)
    for word, count in counter.items():
        groupedcounts[count].append(word)
    del counter

    grouped_list = list(groupedcounts.items())
    del groupedcounts
    grouped_list.sort(key=lambda x: -x[0])
    
    for count, words in grouped_list:
        suffix = b'\t' + str(count).encode('utf-8') + b'\n'
        words.sort()
        for word in words:
            stdout.buffer.write(word)
            stdout.buffer.write(suffix)

if __name__ == '__main__':
    word_count()
