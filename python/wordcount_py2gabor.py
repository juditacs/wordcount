#!/usr/bin/env python2
from sys import stdin

def counter():
    keyWords = {}
    for l in stdin:
        for word in l.split():
            if word in keyWords:
                keyWords[word] += 1
            else:
                keyWords[word] = 1

    keyCounts = {}
    for word in keyWords.keys():
        count = keyWords[word]
        if count in keyCounts:
            keyCounts[count].append(word)
        else:
            keyCounts[count] = [word]

    for count in sorted(keyCounts, reverse = True):
        for word in sorted(keyCounts[count]):
            print word+'\t'+str(count)

if __name__ == '__main__':
    counter()
