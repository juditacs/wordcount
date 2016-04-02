#!/usr/bin/env python2
from sys import argv, stdin
from argparse import ArgumentParser
from subprocess import Popen, PIPE


def parse_args():
    p = ArgumentParser()
    p.add_argument('-b', '--bin-mapping', type=str,
                   default='binary_mapping.txt',
                   help='binary-source code mapping')
    p.add_argument('-r', '--results', type=str, default='')
    return p.parse_args()


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
    print('| Rank | Experiment | CPU seconds | User time | '
          'Maximum memory | Contributor |')
    print('| :---: | :---: | :---: | :---: | :---: | :---: |')
    for rank, (src, res) in enumerate(sorted(
            results.iteritems(), key=lambda x: x[1][0])):
        print(u'| {0} | {1} | {2} | {3} | {4} | {5} | '.format(
            rank+1, src, res[0], res[1], res[2],
            ', '.join(res[3])).encode('utf8'))


def read_binary_mapping(fn):
    with open(fn) as f:
        binaries = {}
        for l in f:
            fd = l.decode('utf8').strip().split('\t')
            binaries[fd[0]] = fd[1]
        return binaries


def match_contributors(results, bin_map):
    for binary, result in results.iteritems():
        if binary in bin_map:
            src = bin_map[binary]
        else:
            # use binary name if not specified
            src = binary.split()[-1]
        ctr = get_contributors(src)
        result.append(ctr)


def get_contributors(fn):
    p = Popen('git blame --incremental {}'.format(fn),
              shell=True, stdout=PIPE).stdout.read()
    contributors = []
    emails = {}
    lines = p.split('\n')
    for i, l in enumerate(lines):
        if not l.startswith('author '):
            continue
        c = l.decode('utf8').split(' ')
        nam = ' '.join(c[1:])
        email = lines[i+1].decode('utf8').split()[1]
        if email not in emails:
            emails[email] = nam
            if not nam in contributors:
                contributors.append(nam)
    return contributors


def main():
    args = parse_args()
    results_fn = args.results
    if results_fn:
        with open(argv[1]) as result_fn:
            results = read_results(result_fn)
    else:
        results = read_results(stdin)
    binary_mapping = read_binary_mapping(args.bin_mapping)
    match_contributors(results, binary_mapping)
    print_markdown_table(results)

if __name__ == '__main__':
    main()
