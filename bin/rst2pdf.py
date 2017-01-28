#!/usr/bin/env python
"""
Does a quick compilation of a '.rst' file to a '.pdf'.
"""

import os
import glob
import argparse
import subprocess

def parse_args(opts=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('file', help='.rst file to convert')
    parser.add_argument('-d', '--delete',
            action='store_true',
            help='deletes latex file')
    return parser.parse_args(opts)

def main(args):
    texfile = args.file + '.tex'
    proc = subprocess.Popen(['rst2latex.py', args.file], stdout=subprocess.PIPE)
    out, err = proc.communicate()
    with open(texfile, 'wb') as f:
        f.write(out)
    subprocess.call(['pdflatex', texfile])
    extensions = ['.aux', '.log', '.out']
    for extension in extensions:
        logfile = args.file + extension
        if os.path.isfile(logfile):
            os.remove(logfile)
    if args.delete:
        os.remove(texfile)

if __name__ == '__main__':
    args = parse_args()
    main(args)
