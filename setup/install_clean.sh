#!/bin/sh

cd ${HOME}/dotfiles/

for file in $(ls | grep -v setup); do

    if [ -f ${HOME}/.$file ]; then
        if [ ! -d ${HOME}/dotfiles/setup/dotfiles_old ]; then
            mkdir ${HOME}/dotfiles/setup/dotfiles_old
        fi
        echo "moving ${HOME}/.$file to \
            ${HOME}/dotfiles/setup/dotfiles_old/$file"
        mv ${HOME}/.$file ${HOME}/dotfiles/setup/dotfiles_old/$file
    fi
done

source ${HOME}/dotfiles/setup/install.sh
