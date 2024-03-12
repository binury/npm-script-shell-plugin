#!/usr/bin/env zsh

# TODO: set these but locally?
# set -o err_return
# set -o no_unset
# set -o pipefail

_preexec () {
  if [[ ! -n $1 ]]; then
    return 0
  fi
  local cmd=${1%% *}
  if [[ -n $(command -v "$cmd") ]]; then
    return 0
  else
    echo "FOOL!"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec _preexec
