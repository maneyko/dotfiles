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
RELATIVE_PATH = EXEC_DIR.split(HOME)[1][1:]  # Relative to HOME

os.chdir(HOME)

def parse_args(args=None):
    parser = argparse.ArgumentParser(description=__doc__.format(EXCLUDES))
    parser.add_argument('-p', '--plugins',
            action='store_true',
            help='install vim plugins (using Vundle)')
    parser.add_argument('-u', '--uninstall',
            action='store_true',
            help='remove symlinked dotfiles')
    return parser.parse_args(args)

def backup(path):
    backups = os.path.join(RELATIVE_PATH, 'backups/')
    backup_path = os.path.join(backups, path)
    response = input('{!r} exists, move to {!r}? [Y/n] '.format(path, backups))
    if response.lower() not in ['', 'y']:
        return
    if not os.path.exists(backups):
        os.mkdir(backups)
    os.rename(link_path, backup_path)

def main(args):
    for filepath in glob.iglob('{}/*'.format(RELATIVE_PATH)):
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
                backup(link_path)
                if os.path.exists(link_path):  # Chose not to backup
                    continue
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
