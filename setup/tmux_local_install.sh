#!/bin/bash

# https://gist.github.com/ryin/3106801
# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

tmux_v=2.1
libevent_v=2.0.22
ncurses_v=6.0

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
wget -O tmux-${tmux_v}.tar.gz https://github.com/tmux/tmux/releases/download/${tmux_v}/tmux-${tmux_v}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-${libevent_v}-stable/libevent-${libevent_v}-stable.tar.gz
wget https://ftp.gnu.org/gnu/ncurses/ncurses-${ncurses_v}.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-${libevent_v}-stable.tar.gz
cd libevent-${libevent_v}-stable
./configure --prefix=$HOME/local --disable-shared
make
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-${ncurses_v}.tar.gz
cd ncurses-${ncurses_v}
./configure --prefix=$HOME/local
make
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${tmux_v}.tar.gz
cd tmux-${tmux_v}
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make
cp tmux $HOME/local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "$HOME/local/bin/tmux is now available. \
    You can optionally add $HOME/local/bin to your PATH."
unset tmux_v libevent_v ncurses_v
