#!/usr/bin/env python
"""
Does a quick conversion of a .rst file to pdf.
"""

import os
import glob
import argparse
import subprocess

def parse_args(args=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('file', help='.rst file to convert')
    parser.add_argument('-d', '--delete', action='store_true',
            help='deletes latex log files')
    return parser.parse_args(args)

def main(args):
    texfile = args.file.replace('.rst', '.tex')
    proc = subprocess.Popen(['rst2latex.py', args.file], stdout=subprocess.PIPE)
    out, err = proc.communicate()
    with open(texfile, 'wb') as f:
        f.write(out)
    subprocess.call(['pdflatex', texfile])
    if args.delete:
        files = []
        extensions = ['*.aux', '*.log', '*.out']
        for ext in extensions:
            for f in glob.iglob(ext):
                os.remove(f)

if __name__ == '__main__':
    args = parse_args()
    main(args)
