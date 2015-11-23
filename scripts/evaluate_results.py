#!/usr/bin/env python2
from sys import argv, stdin


def read_results(stream):
    res = {}
    for line in stream:
        fd = line.strip().split('\t')
        script = fd[0]
        if script not in res:
            res[script] = [0, 0, 0, 0]
        res[script][0] += float(fd[1])
        res[script][1] += float(fd[2])
        res[script][2] += int(fd[3])
        res[script][3] += 1
    return res


def print_markdown_table(results):
    # header
    print('| Experiment | CPU seconds | User time | Maximum memory |')
    print('| --- | --- | --- | --- |')
    for src, res in sorted(results.iteritems(), key=lambda x: x[1][0] / x[1][3]):
        print('| {0} | {1} | {2} | {3} |'.format(src, res[0] / res[3],
              res[1] / res[3], res[2] / res[3]))


def main():
    if len(argv) > 1:
        with open(argv[1]) as result_fn:
            results = read_results(result_fn)
    else:
        results = read_results(stdin)
    print_markdown_table(results)

if __name__ == '__main__':
    main()
