#!/usr/bin/env python3
"""
Creates main file sourced by 'tmux.conf'.

Using the Tmux configuration system proved to be a pain so this is a
script to generate it.
"""

import os
import re
import subprocess

THIS_DIR = os.path.dirname(os.path.realpath(__file__))
OUTPUT = os.path.join(THIS_DIR, '_tmux.conf')
LINES = []

env = os.environ

def sh(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL):
    proc = subprocess.Popen([cmd], shell=True, stdout=stdout, stderr=stderr)
    out, err = proc.communicate()
    return out.decode('utf-8').strip()

TMUX_VERSION = tuple(map(int, sh('tmux -V').split()[-1].split('.')))

def set(text):
    LINES.append('set ' + text)

def bind_key(text):
    LINES.append('bind-key ' + text)

def unbind_defaults():
    keys_text = sh('tmux list-keys')
    default_keys = re.findall('-T (?:prefix|root) (.*) ', keys_text,
                              re.MULTILINE)
    for line in default_keys:
        key = line.split()[0]
        if key == ';':
            LINES.append('unbind-key \\' + key)
        else:
            LINES.append('unbind-key {!r}'.format(key))

def set_default_command():
    namespace = 'reattach-to-user-namespace'
    if sh('which ' + namespace):
        command = namespace + ' -l ' + env['SHELL']
    else:
        command = env['SHELL']
    set('-g default-command {!r}'.format(command))

def set_prefix():
    if env['HOME'] == '/Users/maneyko':
        prefix = 'M-a'
    else:
        prefix = 'M-s'
    set('-g prefix {!r}'.format(prefix))

def root_bindings():
    namespace = 'reattach-to-user-namespace'
    binds = {i: 'select-window -t :={:d}'.format(i) for i in range(10)}
    binds.update({
        'h': 'select-pane -L',
        'j': 'select-pane -D',
        'k': 'select-pane -U',
        'l': 'select-pane -R',
        'x': 'kill-pane',
        '[': 'copy-mode',
        ']': """run-shell
                "{0} pbpaste
                | tmux load-buffer -
                && tmux paste-buffer" """.format(
             namespace).replace('\n', '')
    })
    for key, value in binds.items():
        key = 'M-{}'.format(key)
        bind_key('-n {!r} {}'.format(key, value))

def recursive_bindings():
    bind_key('-r h resize-pane -L')
    bind_key('-r j resize-pane -D')
    bind_key('-r k resize-pane -U')
    bind_key('-r l resize-pane -R')
    bind_key('-r Down  select-pane -D')
    bind_key('-r Left  select-pane -L')
    bind_key('-r Right select-pane -R')
    bind_key('-r Up    select-pane -U')

def regular_bindings():
    binds = {i: 'select-window -t :={:d}'.format(i) for i in range(10)}
    binds.update({
        ':': 'command-prompt',
        ',': 'command-prompt -I "rename-window "',
        'b': 'split-window -v -c "#{pane_current_path}"',
        'v': 'split-window -h -c "#{pane_current_path}"',
        'c': 'new-window      -c "#{pane_current_path}"',
        'n': 'next-window',
        'p': 'previous-window',
        'q': 'confirm-before -p "kill-window? (y/n)" kill-window',
        'r': 'source-file ~/.tmux.conf; display "Config Reloaded!"',
        's': 'setw synchronize-panes; display "Toggle Sync"',
        'w': 'list-windows',
        'x': 'kill-pane',
        '{': 'swap-pane -U',
        '}': 'swap-pane -D',
        'B': 'break-pane',
        'D': 'detach',
        "'M-q'": 'confirm-before -p "kill-server? (y/n)" kill-server'
    })
    for key, value in binds.items():
        value = value.replace(';', '\;')
        bind_key('{} {}'.format(key, value))


def vi_bindings():
    set('-gw mode-keys vi')
    namespace_copy = 'reattach-to-user-namespace pbcopy'
    binds = {
        'u': 'halfpage-up',
        'd': 'halfpage-down',
        'o': 'scroll-down',
        'p': 'scroll-up',
        'v': 'begin-selection',
        'y': 'copy-pipe "{}"'.format(namespace_copy),
        'Y': 'copy-end-of-line',
        'Enter': 'copy-pipe "{}"'.format(namespace_copy),
        'Down': 'scroll-down',
        'Up': 'scroll-up'
    }
    for key, value in binds.items():
        bind_key('-t vi-copy {} {}'.format(key, value))

def set_preferences():
    set('-g renumber-windows on')  # Renumber windows when a window is closed
    set('-g base-index 1')         # Start renumbering at 1
    set('-g repeat-time 750')      # Default is 500mc
    set('-s escape-time 0')        # Escape immediately leaves tmux
    if TMUX_VERSION >= (2, 1):
        set('-g mouse on')
    else:
        set('-g mouse-select-pane on')

def set_colors():
    TERM = 'screen-256color'
    set('-g default-terminal {!r}'.format(TERM))
    color_inactive = 19
    color_active = 183
    set('-gw pane-border-style "fg=colour{:d}"'.format(color_inactive))
    set('-gw pane-active-border-style "fg=colour{:d}"'.format(color_active))
    set('-g status-bg black')
    set('-g status-fg white')
    set('-g status-left {!r}'.format(''))
    set('-g status-right {!r}'.format('#(. ~/.tmux/bar.sh)'))

def functions():
    # Creates 4 panes with 2 main at the top and 2 smaller below then
    # refocuses at top left pane.
    height = 12
    bind_key("'M-n' " + '\; '.join([
        'new-window',
        'split-window -v',
        'split-window -h',
        'select-pane -U',
        'split-window -h',
        'select-pane -L',
        'resize-pane -D {}'.format(height),
        'select-pane -D',
        'swap-pane -U',
        'select-pane -D',
        'swap-pane -U',
        'resize-pane -R 25',
        'select-pane -U',
        'select-pane -L'
    ]))
    # Creates 2 vertical panes in new window
    bind_key('N ' + '\; '.join([
        'new-window',
        'split-window -h',
        'select-pane -L'
    ]))
    # Copys line above cursor to system clipboard
    bind_key("-n 'M-Y' " + '\; '.join([
        'copy-mode',
        'send-keys k0v$\;hy',
        'display "Yanked line above"'
    ]))
    # Copys current line to system clipboard
    bind_key("-n 'M-U' " + '\; '.join([
        'copy-mode',
        'send-keys 0f',
        "send-keys 'Space'",
        'send-keys lv$\hy',
        "send-keys 'C-u'"
    ]))

def write_file():
    with open(os.path.join(OUTPUT), 'w') as f:
        f.write('# This file was created by {}\n'.format(
                os.path.realpath(__file__)))
        f.write('\n'.join(LINES))

if __name__ == '__main__':
    unbind_defaults()
    set_default_command()
    set_prefix()
    root_bindings()
    recursive_bindings()
    regular_bindings()
    vi_bindings()
    set_preferences()
    set_colors()
    functions()
    write_file()
