#!/usr/bin/env python
"""
Links all files in ``dotfiles/``, with the exception of {}, to HOME
directory.
"""

import os
import glob
import argparse
import subprocess
from six.moves import input

EXCLUDES = [os.path.basename(__file__)]  # README (if there was one)
if os.uname()[0] != 'Darwin':
    EXCLUDES.append('mac')

HOME = os.environ['HOME']
EXEC_DIR = os.path.dirname(os.path.realpath(__file__))
REL_PATH = EXEC_DIR.split(HOME)[1][1:]

os.chdir(HOME)

def parse_args():
    parser = argparse.ArgumentParser(description=__doc__.format(EXCLUDES))
    parser.add_argument('-p', '--plugins', action='store_true',
            help='install vim plugins (using Vundle)')
    parser.add_argument('-u', '--uninstall', action='store_true',
            help='remove symlinked dotfiles')
    return parser.parse_args()

def main(args):
    for filepath in glob.iglob('{}/*'.format(REL_PATH)):
        basename = os.path.basename(filepath)
        if basename in EXCLUDES:
            continue
        link_path = '.{}'.format(basename)
        if args.uninstall:
            if os.path.islink(link_path):
                os.unlink(link_path)
                print('Removed {!r}'.format(link_path))
        else:
            if os.path.exists(link_path):
                backups = os.path.join(REL_PATH, 'backups/')
                backup = os.path.join(backups, basename)
                response = input('{!r} exists, move to {!r}? [Y/n] '.format(
                                 link_path, backup))
                if response.lower() not in ['', 'y']:
                    continue
                else:
                    if not os.path.exists(backups):
                        os.makedirs(backups)
                    os.rename(link_path, backup)
            os.symlink(filepath, link_path)
            print('Linked: {!r:25s} -> {!r}'.format(filepath, link_path))
    if args.plugins:
        repo = 'https://github.com/VundleVim/Vundle.vim'
        path = os.path.join(HOME, '.vim/bundle/Vundle.vim')
        if not os.path.exists(path):
            subprocess.call(['git', 'clone', repo, path])
        subprocess.call(['vim', '+PluginInstall', '+qall'])

if __name__ == '__main__':
    args = parse_args()
    main(args)
