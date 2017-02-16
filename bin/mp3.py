#!/usr/bin/env python

import re
import argparse

import tabulate
import mutagen.easyid3
import mutagen.easymp4

def parse_args(opts=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('files',
            nargs='+',
            type=argparse.FileType('r'),
            help='MP3 or M4A files')
    parser.add_argument('-p', '--print',
            action='store_true',
            default=True,
            help='print file info (defaults to %(default)s)')
    parser.add_argument('-s',
            metavar=('PAT' , 'REPL', 'FIELD'),
            nargs=3,
            help='use regular expression substitution on field')
    parser.add_argument('-d', '--dry-run',
            action='store_true',
            help='preview changes with substitution')
    return parser.parse_args(opts)

def load(fileobj):
    """Loads a file object as a mutagen tag."""
    if not fileobj.closed:
        fileobj.close()
    path = fileobj.name
    if path.endswith('.mp3'):
        return mutagen.easyid3.EasyID3(path)
    elif path.endswith('.m4a') or path.endswith('.mp4'):
        return mutagen.easymp4.EasyMP4(path)

def pprint(tags):
    """Prints table of mutagen tags with keys as headers."""
    keys = set( key for tag in tags for key in tag.keys() )
    d = {key: [] for key in sorted(keys)}
    for tag in tags:
        for key, value in tag.items():
            d[key].append(value[0])
    print(tabulate.tabulate(d, headers='keys'))

def edit(tag, pat, repl, field):
    """Evaluates regexp substitution on mutagen tag."""
    try:
        new = re.sub(pat, repl, tag[field][0])
        tag[field] = [new]
    except KeyError:
        pass

def main(args):
    tags = [ load(f) for f in args.files ]
    if args.__getattribute__('print'):
        pprint(tags)
    if args.s:
        pat, repl, field = args.s
        for tag in tags:
            edit(tag, pat, repl, field)
            if not args.dry_run:
                tag.save()
        print('\n{:=^30}'.format(' Result '))
        pprint(tags)

if __name__ == '__main__':
    args = parse_args()
    main(args)
