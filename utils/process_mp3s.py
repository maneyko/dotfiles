#!/usr/bin/env python3
"""
    Usage:
        {script} [CONFIG.json] [FILES.mp3]

    Possible Tags:
        album, albumartist, artist, composer, copyright, date,
        discnumber, genre, title, tracknumber
"""

import json
import os
from sys import argv
from mutagen.easyid3 import EasyID3
from mutagen.easymp4 import EasyMP4

def change_tags(paths: list, config: dict):
    for path in paths:
        if path[-4:].lower() == '.m4a':
            tag = EasyMP4(path)
        elif path[-4:].lower() == '.mp3':
            tag = EasyID3(path)
        else:
            raise Exception('Bad file extension')
        for key, value in config.items():
            tag[key] = value
        tag.save()

def doc_and_quit(code=1):
    print(__doc__.format(script=script))
    quit(code)

if __name__ == '__main__':
    script = os.path.basename(argv[0])
    if len(argv) < 2:
        doc_and_quit()
    elif not os.path.isfile(argv[1]):
        doc_and_quit()
    config = json.load(open(argv[1]))
    mp3s = argv[2:]
    if not mp3s:
        doc_and_quit()
    change_tags(mp3s, config)
