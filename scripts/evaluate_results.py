#!/usr/bin/env python2
from sys import argv, stdin


def read_results(stream):
    res = {}
    for line in stream:
        fd = line.strip().split('\t')
        script = fd[0]
        if script not in res:
            res[script] = []
        r = [float(fd[1]), float(fd[2]), int(fd[3])]
        res[script].append(r)
    maxres = {}
    for k, v in res.iteritems():
        maxres[k] = min(v, key=lambda x: x[1])
    return maxres


def print_markdown_table(results):
    # header
    print('| Rank | Experiment | CPU seconds | User time | Maximum memory |')
    print('| :---: | :---: | :---: | :---: | :---: |')
    for rank, (src, res) in enumerate(sorted(
            results.iteritems(), key=lambda x: x[1][0])):
        print('| {0} | {1} | {2} | {3} | {4} |'.format(
            rank+1, src, res[0], res[1], res[2]))


def main():
    if len(argv) > 1:
        with open(argv[1]) as result_fn:
            results = read_results(result_fn)
    else:
        results = read_results(stdin)
    print_markdown_table(results)

if __name__ == '__main__':
    main()
