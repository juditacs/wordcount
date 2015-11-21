#!/usr/bin/env python3
from collections import defaultdict
from sys import stdin


def word_count():
    counter = defaultdict(int)
    for l in stdin:
        for word in l.split():
            counter[word] += 1
    for word, cnt in sorted(counter.items(), key=lambda x: (-x[1], x[0])):
        print('{0}\t{1}'.format(word, cnt))

if __name__ == '__main__':
    word_count()
