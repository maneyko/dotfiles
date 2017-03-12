#!/usr/bin/env python
"""
Symlinks all files in '{}/' (with a '.' prepended) to HOME directory,
with the exceptions of {}.
"""

import os
import glob
import argparse
import subprocess
from six.moves import input

BACKUP_DIR = '_backups'
HOME = os.environ['HOME']
EXEC_DIR = os.path.dirname(os.path.realpath(__file__))
DOT_RELPATH = os.path.relpath(EXEC_DIR, HOME)

EXCLUDES = [os.path.basename(__file__), BACKUP_DIR, 'README']
if os.uname()[0] != 'Darwin':
    EXCLUDES.append('mac')

os.chdir(HOME)

def parse_args(opts=None):
    parser = argparse.ArgumentParser(
            description=__doc__.format(DOT_RELPATH, EXCLUDES))
    parser.add_argument('-p', '--plugins',
            action='store_true',
            help='install vim plugins (using Vundle)')
    parser.add_argument('-u', '--uninstall',
            action='store_true',
            help='remove symlinked dotfiles')
    return parser.parse_args(opts)

def backup(filepath):
    backups = os.path.join(DOT_RELPATH, BACKUP_DIR)
    backup_base = os.path.basename(filepath.lstrip('.'))
    backup_dst = os.path.join(backups, backup_base)
    response = input('{!r} exists, move to {!r}? [Y/n] '.format(
                     filepath, backup_dst))
    if response.lower() not in ['', 'y']:
        return
    if not os.path.exists(backups):
        os.mkdir(backups)
    os.rename(filepath, backup_dst)

def main(args):
    for link_src in glob.iglob(os.path.join(DOT_RELPATH, '*')):
        link_base = os.path.basename(link_src)
        if link_base in EXCLUDES:
            continue
        link_dst = '.{}'.format(link_base)
        if args.uninstall:
            if os.path.islink(link_dst):
                os.unlink(link_dst)
                print('Removed {!r}'.format(link_dst))
        else:
            if os.path.exists(link_dst):
                backup(link_dst)
                if os.path.exists(link_dst):  # Chose not to backup
                    continue
            os.symlink(link_src, link_dst)
            print('Linked: {!r:25s} -> {!r}'.format(link_src, link_dst))
    if args.plugins:
        repo = 'https://github.com/VundleVim/Vundle.vim'
        dest = os.path.join(HOME, '.vim/bundle/Vundle.vim')
        if not os.path.exists(dest):
            subprocess.call(['git', 'clone', repo, dest])
        subprocess.call(['vim', '+PluginInstall', '+qall'])

if __name__ == '__main__':
    args = parse_args()
    main(args)