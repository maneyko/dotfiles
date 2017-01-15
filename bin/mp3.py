#!/usr/bin/env python

import argparse
import re

import tabulate
import mutagen.easyid3
import mutagen.easymp4

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('files', nargs='+', type=argparse.FileType('r'),
            help='MP3 or M4A files')
    parser.add_argument('-p', '--print', default=True, action='store_true',
            help='Print file info (defaults to %(default)s)')
    parser.add_argument('-s', metavar=('PAT' , 'REPL', 'FIELD'), nargs=3,
            help='Use regular expression substitution on field')
    parser.add_argument('-d', '--dry-run', action='store_true',
            help='Preview changes with substitution')
    return parser.parse_args()

def load(fileobj):
    fileobj.close()
    path = fileobj.name
    if path.endswith('.mp3'):
        return mutagen.easyid3.EasyID3(path)
    elif path.endswith('.m4a') or path.endswith('.mp4'):
        return mutagen.easymp4.EasyMP4(path)

def pprint(tags):
    keys = set( key for tag in tags for key in tag.keys() )
    d = { key: [] for key in sorted(keys) }
    for tag in tags:
        for key in tag.keys():
            d[key].append(tag[key][0])
    print(tabulate.tabulate(d, headers='keys'))

def edit(tag, pat, repl, field):
    try:
        new = re.sub(pat, repl, tag[field][0])
        tag[field] = [new]
    except KeyError:
        pass

def main():
    args = parse_args()
    files = [ load(f) for f in args.files ]
    if args.__getattribute__('print'):
        pprint(files)
    if args.s:
        pat, repl, field = args.s
        for f in files:
            edit(f, pat, repl, field)
            if not args.dry_run:
                [ f.save() for f in files ]
        print('\n{:=^30}'.format(' Result '))
        pprint(files)

if __name__ == '__main__':
    main()
