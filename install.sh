#!/bin/bash

clr() {  # (number, text)
  printf "\033[38;5;${1}m${2}\033[0m"
}

__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

EXCEPTIONS=('_backups' 'README' 'install.sh')
exceptions_str="${EXCEPTIONS[@]}"

read -r -d '' helptext << EOT
Symlinks all files in ~/.dotfiles/ (with a '.' prepended) to HOME directory,
with the exceptions of '${exceptions_str// /, }'

Usage:  ~/.dotfiles/install.sh [OPTIONS]

Options:

  $(clr 3 "-h, --help")            Print this help
  $(clr 3 "-p, --no-plugins")      Don't install vim plugins
  $(clr 3 "-u, --uninstall")       Uninstall maneyko's dotfiles
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
    -p|--no-plugins)
      no_plugins="true"
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

if test -n "$print_help"; then
  echo "$helptext"
  exit 0
fi

for f in "$__DIR__"/*; do

  fbase="$(basename "$f")"
  dotf=."${fbase}"
  home_dotf="${HOME}/${dotf}"

  test -n "$(echo "${EXCEPTIONS[@]}" | grep "$fbase")" && continue

  if test -n "$uninstall_opt"; then
    test -L "$home_dotf" && rm -v "$home_dotf"
    continue
  fi

  if test -e "$home_dotf"; then

    printf "$home_dotf exists, move to ${__DIR__}/_backups/${dotf}? [Y/n] "
    read res

    if test -z "$res" -o "$res" = 'Y' -o "$res" = 'y'; then
      mv "$home_dotf" "${__DIR__}/_backups/"
    else
      continue
    fi

    ln -vs "${__DIR__}/${fbase}" "$home_dotf"
  fi
done

if test -z "$no_plugins"; then
  curl -fLo $HOME/.vim/autoload/plug.vim \
    --create-dirs \
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  vim +PlugInstall +qall

  if test -n "$(command -v nvim)"; then
    curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim \
      --create-dirs \
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    python3 -m pip install pynvim --upgrade
    nvim +PlugInstall +qall
    nvim +UpdateRemotePlugins +qall
  fi
fi
