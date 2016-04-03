#!/usr/bin/env python3
from collections import defaultdict
from sys import stdin
from sys import stdout
import codecs


def word_count():
    counter = defaultdict(int)
    for l in stdin.buffer:
        for word in l.split():
            counter[word] += 1
    wordlist = [(word,count) for word,count in counter.items()]
    del counter  # Free the memory, man!
    wordlist.sort(key=lambda x: (-x[1], x[0]))

    # Print as bytes
    for word, count in wordlist:
        stdout.buffer.write(word + b'/t' + str(count).encode('utf-8'))

if __name__ == '__main__':
    word_count()
