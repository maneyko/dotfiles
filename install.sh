#!/bin/bash

clr() {  # (number, text)
  printf "\033[38;5;${1}m${2}\033[0m"
}

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

test "$__DIR__" != "$HOME/.dotfiles" -a ! -d "$HOME/.dotfiles" && {
  clr 2 "Moving repo to ~/.dotfiles\n"
  cd
  mv "$__DIR__" "$HOME/.dotfiles"
}

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

cd

for f in "${FILES_TO_LINK[@]}"; do
  dotf=".$f"
  test -n "$uninstall_opt" && {
    test -L "$dotf" && rm -v "$dotf"
    continue
  }
  test -e "$dotf" && {
    printf "~/$dotf exists, move to ~/.dotfiles/_backups/${f}? [Y/n] "
    read res
    test -z "$res" -o "$res" = 'Y' -o "$res" = 'y' && {
      mv -v "$dotf" "$__DIR__/_backups/$f"
    } || {
      continue
    }
  }
  ln -vs ".dotfiles/$f" "$dotf"
done

test -n "$uninstall_opt" && exit 0

vim_path="$(type -P nvim vim vi | head -1)"
vim="$(basename $vim_path)"

test "$vim" = 'nvim' && {
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
      'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  vim_config=$HOME/.dotfiles/config/nvim/init.vim
  test -n "$vim_full" && {
    python3 -m pip install pynvim --upgrade
  }
} || {
  curl -fLo $HOME/.vim/autoload/plug.vim \
    --create-dirs \
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  vim_config=$HOME/.dotfiles/config/nvim/init.vim
}

test -z "$vim_full" && {
  perl -i -pe 's/minimal_vimrc = ([\d]+)/minimal_vimrc = 1/g' $vim_config
}

$vim +PlugInstall +qall

test "$vim" = 'nvim' && {
  $vim +UpdateRemotePlugins +qall
  rm -f ~/.config/nvim/plugged/vim-plug/.git/objects/pack/*.pack  2>/dev/null
} || {
  rm -f ~/.vim/plugged/vim-plug/.git/objects/pack/*.pack          2>/dev/null
}
