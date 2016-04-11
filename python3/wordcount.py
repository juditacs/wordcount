#!/usr/bin/env python3
from collections import defaultdict
from sys import stdin
import codecs

stdin = codecs.getreader('utf8')(stdin.detach(), errors='ignore')


def word_count():
    counter = defaultdict(int)
    for l in stdin:
        for word in bytes(l, 'utf8').split():
            counter[word] += 1
    for word, cnt in sorted(counter.items(), key=lambda x: (-x[1], x[0])):
        print('{0}\t{1}'.format(word.decode('utf8'), cnt))

if __name__ == '__main__':
    word_count()
