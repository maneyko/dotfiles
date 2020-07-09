#!/bin/bash

clr() {  # (number, text)
  printf "\033[38;5;${1}m${2}\033[0m"
}

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

FILES_TO_LINK=(
bash_profile
bashrc
inputrc
nvimrc
tmux.conf
vimrc
bin
config
ipython
vim
)

read -r -d '' helptext << EOT
Symlinks [$(echo "${FILES_TO_LINK[@]}" \
              | perl -pe "s/(\S+)/'\1',/g; s/.\$//s")]
in ~/.dotfiles/ (with a '.' prepended) to HOME directory.

Usage:  ~/.dotfiles/install.sh [OPTIONS]

Options:
  $(clr 3 '-h, --help')             Print this help
  $(clr 3 '-f, --vim-full')         Install all vim plugins (~100M)
  $(clr 3 '-u, --uninstall')        Uninstall maneyko's dotfiles
EOT


POSITIONAL=()
while test $# -gt 0
do
  key=$1
  case $key in
    -h|--help)
      print_help="true"
      shift  # past argument
      ;;
    -f|--vim-full)
      vim_full="true"
      shift  # past argument
      ;;
    -u|--uninstall)
      uninstall_opt="true"
      shift  # past argument
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done
set -- "${POSITIONAL[@]}"  # Restore positional parameters

test -n "$print_help" && {
  echo "$helptext"
  exit 0
}

test "$__DIR__" != "$HOME/.dotfiles" -a ! -d "$HOME/.dotfiles" && {
  clr 3 "Moving repo to ~/.dotfiles\n"
  cd
  mv "$__DIR__" "$HOME/.dotfiles"
}

__DIR__="$HOME/.dotfiles"

cd

for f in "${FILES_TO_LINK[@]}"; do
  dotf=".$f"
  if test -n "$uninstall_opt"; then
    test -L "$dotf" && rm -v "$dotf"
    continue
  fi
  if test -e "$dotf"; then
    echo
    printf "~/$dotf exists, move to ~/.dotfiles/_backups/${f}? [Y/n] "
    read res
    if test -z "$res" -o "$res" = 'Y' -o "$res" = 'y'; then
      mv -v "$dotf" "$__DIR__/_backups/$f"
    else
      continue
    fi
  fi
  ln -vs ".dotfiles/$f" "$dotf"
done

if test -n "$uninstall_opt"; then
  backups="$__DIR__/_backups/*"
  # Check if directory is not empty
  if test ! "$(printf "${backups[0]}")" == "$(printf $backups)"; then
    echo
    cat << EOT

There is something in '$__DIR__/_backups'
I will move it for you so you do not lose it.

EOT
    mv -v "$__DIR__/_backups" "$HOME/.dotfiles.bak"
  fi

  exit 0
fi

vim_path="$(type -P nvim vim vi | head -1)"
vim="$(basename $vim_path)"

if test "$vim" = 'nvim'; then
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
      'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  vim_config=$HOME/.dotfiles/nvimrc
  if test -n "$vim_full"; then
    python3 -m pip install pynvim --upgrade
  fi
else
  curl -fLo $HOME/.vim/autoload/plug.vim \
    --create-dirs \
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  vim_config=$HOME/.dotfiles/vimrc
fi

test -z "$vim_full" && {
  perl -i -pe 's/minimal_vimrc = ([\d]+)/minimal_vimrc = 1/g' $vim_config
}

$vim +PlugInstall +qall

if test "$vim" = 'nvim'; then
  $vim +UpdateRemotePlugins +qall
  rm -f ~/.config/nvim/plugged/vim-plug/.git/objects/pack/*.pack  2>/dev/null
else
  rm -f ~/.vim/plugged/vim-plug/.git/objects/pack/*.pack          2>/dev/null
fi
