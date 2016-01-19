#!/bin/sh

cd ~/dotfiles/
setup/remove

if [ -d ~/dotfiles/setup/dotfiles_old ]; then
    cd ~/dotfiles/setup/dotfiles_old/
    for file in $(ls); do
        echo "moving ~/dotfiles/setup/dotfiles_old/$file to ~/.$file"
        mv $file ~/.$file
    done
    rmdir ~/dotfiles/setup/dotfiles_old/
fi

