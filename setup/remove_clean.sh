#!/bin/sh

cd $HOME/dotfiles/
setup/remove.sh

if [ -d $HOME/dotfiles/setup/dotfiles_old ]; then
    cd $HOME/dotfiles/setup/dotfiles_old/
    for file in $(ls); do
        echo "moving ~/dotfiles/setup/dotfiles_old/$file to ~/.$file"
        mv $file $HOME/.$file
    done
    rmdir $HOME/dotfiles/setup/dotfiles_old/
fi

