#!/bin/sh

setup_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dotfile_dir=$setup_dir/..
dotfile_backup=$setup_dir/dotfiles_old

cd $dotfile_dir/../

read -s -n 1 -p \
    "Remove dotfiles in $PWD/ ? ( [y]/N ) " response
echo
case $response in
    [yY]|"")
        for file in $(ls $dotfile_dir | grep -Ev 'README|setup'); do
            rm -v $PWD/.$file 2>/dev/null
        done
        ;;
    *)
        echo Not removing dotfiles
        ;;
esac

if [ -d $dotfile_backup ]; then
    read -s -n 1 -p \
        "Move files in $dotfile_backup/ back to $PWD/ ?\
        ( [y]/N ) " response
    echo
    case $response in
        [yY]|"")
            for file in $(ls $dotfile_backup); do
                echo "Moving $dotfile_backup/$file to $PWD/.$file"
                mv $dotfile_backup/$file $PWD/.$file
            done
            rm -fr $dotfile_backup
            ;;
        *)
            echo Old dotfiles are still located at $dotfile_backup
            ;;
    esac
fi
unset setup_dir dotfile_dir dotfile_backup
echo Successfully finished removal
