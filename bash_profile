#!/bin/bash

test -n "$COLORS" && return

test -f $HOME/.bashrc && {
  source $HOME/.bashrc
}
