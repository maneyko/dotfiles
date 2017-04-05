#!/usr/bin/env python
"""
Listens for changes to a '.rst' file then converts it to a specific
format. The default converts the file to HTML.
"""

from __future__ import print_function
import os
import argparse
import subprocess


def parse_args(opts=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('file', help='.rst file to listen for changes')
    parser.add_argument('-p', '--pdf',
            action='store_true',
            help='convert to pdf file')
    args = parser.parse_args(opts)
    if not os.path.isfile(args.file):
        return parser.error('file {!r} does not exist!'.format(args.file))
    return parser.parse_args(opts)


def listen(filename, command):
    listener = 'when-changed {!r} {!r}'.format(filename, command)
    print("""Listening with command::

    {}
    """.format(listener))
    try:
        proc = subprocess.Popen([listener], shell=True)
        proc.communicate()
    except KeyboardInterrupt:
        print('\nCleaning up...', end='')
        proc.terminate()
        print('done')


def main(args):
    if args.pdf:
        command = 'rst2pdf.py {0} -d'.format(args.file)
    else:
        html_dir = 'html'
        if not os.path.isdir(html_dir):
            os.mkdir(html_dir)
        output = os.path.join(html_dir, args.file) + '.html'
        command = 'rst2html.py {0} > {1}'.format(args.file, output)
    listen(args.file, command)


if __name__ == '__main__':
    args = parse_args()
    main(args)
