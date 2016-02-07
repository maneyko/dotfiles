#!/bin/sh

setup_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dotfile_dir=$setup_dir/..
dotfile_backup=$setup_dir/dotfiles_old

read -s -n 1 -p \
  "Back up dotfiles that will be removed ([y]/N)? " response
echo
case $response in
  [yY]|"")
    printf "%s" "Creating backup directory and moving files..."

    for file in $(ls $dotfile_dir | grep -Ev 'README|setup'); do
      if [ -f $dotfile_dir/../.$file ]; then
        if [ ! -d $dotfile_backup ]; then
          mkdir $dotfile_backup
        fi
        mv $dotfile_dir/../.$file $dotfile_backup/$file
      fi
    done; echo done
    echo Your dotfiles have been moved to .dotfiles/setup/dotfiles_old/
    ;;
  *)
    echo Will overwrite conflicting dotfiles
    ;;
esac

cd $dotfile_dir/../
read -s -n 1 -p "Create symlinks to $PWD/ ([y]/N)? " response
echo
case $response in
  [yY]|"")
    printf "%s" "Creating symlinks..."
    for file in $(ls $dotfile_dir | grep -Ev 'README|setup'); do
      ln -fs .dotfiles/$file .$file
    done; echo done
    ;;
  *)
    echo No symlinks created to $PWD/
    ;;
esac

echo Sourcing new bashrc
source $dotfile_dir/bashrc

printf "%s" "Updating ~/.vim/ftplugin/man.vim ..."
cd $dotfile_dir/vim/ftplugin/
rm man.vim 2>/dev/null
wget -q https://raw.githubusercontent.com/vim/vim/master/runtime/ftplugin/man.vim
echo done

read -s -n 1 -p \
  "Install vim plugins to ~/.vim/bundle/ ([y]/N)? " response
echo
case $response in
  [yY]|"")
    echo Installing plugins
    rm -fr $dotfile_dir/vim/bundle/ 2>/dev/null
    mkdir $dotfile_dir/vim/bundle
    vim +PluginInstall +qall
    ;;
  *)
    echo Skipping PluginInstall
    echo List of plugins can be found in ~/.vimrc
    ;;
esac

if [[ $(tmux -V) == *'1.'* ]]; then
  echo "Tmux is out of date (version 1.x) update?"
  read -s -n 1 -p \
    "May take up to 30 minutes... ([y]/N) " response
  echo
  case $response in
    [yY]|"")
      echo Installing tmux to $HOME/local/bin/tmux
      echo This may take a while...
      rm $HOME/local/bin/tmux 2>/dev/null
      source $setup_dir/tmux_local_install.sh
      ;;
    *)
      echo Will not update tmux
      echo Current version is $(tmux -V)
      ;;
  esac
fi
unset setup_dir dotfile_dir dotfile_backup
echo Successfully finished install
