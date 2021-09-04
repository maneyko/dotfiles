#!/bin/bash

test -n "$BASHRC_LOADED" && return

if test -f "$HOME/.bashrc"; then
  source "$HOME/.bashrc"
fi
