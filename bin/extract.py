#!/usr/bin/env python
"""
Extracts a file of compression types {}.
"""

import os
from argparse import ArgumentParser, RawTextHelpFormatter
import subprocess


DATA = [
    (['.tar.', '.tar', '.tbz2', '.tgz'],
        'tar xvf {!r}'),
    (['.gz'],
        'gunzip {!r}'),
    (['.bz2'],
        'bunzip2 {!r}'),
    (['.dmg'],
        'hdiutil mount {!r}'),
    (['.zip', '.ZIP'],
        'unzip {!r}'),
    (['.rar'],
        'unrar x {!r}'),
    (['.pax'],
        'cat {!r} | pax -r'),
    (['.Z'],
        'uncompress {!r}'),
    (['.pax.Z'],
        'uncompress {!r} --stdout | pax -r')
]


def parse_args(opts=None):
    all_exts = [ext for d in DATA for ext in d[0]]
    parser = ArgumentParser(description=__doc__.format(all_exts),
                            formatter_class=RawTextHelpFormatter)
    parser.add_argument('file', help='compressed file to extract')
    args = parser.parse_args(opts)
    if not os.path.isfile(args.file):
        return parser.error(
                'file {!r} does not exist!'.format(args.file))
    if not contains(all_exts, args.file):
        return parser.error(
                'file extension of {!r} not supported!'.format(args.file))
    return args


def contains(extensions, filename):
    return any(ext in filename for ext in extensions)


def extract(cmd, filename):
    command = cmd.format(filename)
    print("""Executing::

    {}
    """.format(command))
    proc = subprocess.Popen([command], shell=True)
    return proc.communicate()


def main(args):
    for extensions, cmd in DATA:
        if contains(extensions, args.file):
            extract(cmd, args.file)
            return


if __name__ == '__main__':
    args = parse_args()
    main(args)
