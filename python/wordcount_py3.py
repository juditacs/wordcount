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
    
    # Ugly, but we're converting {word:count} to list(words) & (count, word_index)    
    # This is because it is faster to sort the (count, word_index) objects
    wordlist, countlist = list(), list()
    i=0
    for word, count in counter.items():
        wordlist.append(word)
        countlist.append((count, i))
        i = i+1

    del counter  # Free the memory, man!
    countlist.sort(key=lambda x: -x[0])

    # Group words by their counts, and sorting the lists of words with the same count
    for count, word_indices in groupby(countlist, lambda x: x[0]):
        suffix = b'\t' + str(count).encode('utf-8') + b'\n'
        words = list(map(lambda y: wordlist[y[1]], word_indices))
        words.sort()

        for word in words:
            stdout.buffer.write(word)
            stdout.buffer.write(suffix)

if __name__ == '__main__':
    word_count()
