#!/bin/sh

setup_dir=`cd "\` dirname "${BASH_SOURCE[0]}" \`" && pwd`
dotfile_dir=`echo $setup_dir | sed 's%/[^/]*$%%'`
home_dir=`echo $dotfile_dir | sed 's%/[^/]*$%%'`
dotfile_backup=$setup_dir/dotfiles_old
dotfile_plain=`echo $dotfile_dir | sed 's@.*/@@' | tr -d '.'`

for file in `ls $dotfile_dir | grep -Ev 'README|setup'`; do
  if test -f $home_dir/.$file -o -d $home_dir/.$file; then
    conflicting="yes"
  fi
done;

if test "$conflicting"; then
  read -s -n 1 -p \
    "Back up dotfiles that will be removed ([y]/N)? " response
  echo
  case $response in
    [yY]|"")
      printf "Creating backup directory and moving files..."
      mkdir $dotfile_backup 2>/dev/null
      for file in `ls $dotfile_dir | grep -Ev 'README|setup'`; do
        if test -f $home_dir/.$file; then
          mv $home_dir/.$file $dotfile_backup/$file
        fi
      done; echo done
      ;;
    *)
      echo Will overwrite conflicting dotfiles
      ;;
  esac; echo
fi

cd $home_dir
read -s -n 1 -p "Create symlinks to $PWD/ ([y]/N)? " response
echo
case $response in
  [yY]|"")
    printf "Creating symlinks..."
    for file in `ls $dotfile_dir | grep -Ev 'README|setup'`; do
      ln -fs .$dotfile_plain/$file .$file
    done; echo done
    ;;
  *)
    echo No symlinks created to $PWD/
    ;;
esac; echo

printf "Updating ~/.vim/ftplugin/man.vim ..."
mkdir $dotfile_dir/vim/ftplugin/
cd $dotfile_dir/vim/ftplugin/
rm man.vim 2>/dev/null
wget -q https://raw.githubusercontent.com/vim/vim/master/runtime/ftplugin/man.vim
printf "done\n"

read -s -n 1 -p \
  "Install vim plugins to ~/.vim/bundle/ ([y]/N)? " response
echo
case $response in
  [yY]|"")
    echo Installing plugins
    if ! test -d $home_dir/.vim/bundle/Vundle.vim; then
      mkdir -p $home_dir/.vim/bundle
      git clone https://github.com/VundleVim/Vundle.vim.git \
          $home_dir/.vim/bundle/Vundle.vim
    fi
    vim +PluginInstall +qall
    ;;
  *)
    echo Skipping PluginInstall
    ;;
esac; echo

if test "`tmux -V | grep " 1."`"; then
  echo "Tmux is out of date (version 1.x) update?"
  read -s -n 1 -p \
    "May take up to 30 minutes... ([y]/N) " response
  echo
  case $response in
    [yY]|"")
      echo Installing tmux to $HOME/local/bin/tmux
      rm $HOME/local/bin/tmux 2>/dev/null
      $setup_dir/tmux_local_install.sh
      ;;
    *)
      echo Will not update tmux
      echo Current version is `tmux -V`
      ;;
  esac
fi
echo Finished install

cd $home_dir
mv $dotfile_plain .$dotfile_plain 2>/dev/null

