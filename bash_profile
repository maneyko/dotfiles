#!/bin/bash

[[ -n $BASHRC_LOADED ]] && return

if [[ -f $HOME/.bashrc ]]; then
  source "$HOME/.bashrc"
fi
