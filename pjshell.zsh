#!/usr/bin/env zsh

# TODO: set these but locally?
# set -o err_return
# set -o no_unset
# set -o pipefail

local script_matches_cmd

# get_scripts <name_to_match>
function get_scripts {
  # echo "arg: $1"
  # (f) splits newlines
  local scripts=("${(f)$(jq -r '.scripts | to_entries[] | "\(.key)=\(.value)"' package.json)}")
  # TODO: just look for name with jq
  for script in $scripts; do
    local script_name=${script%%=*}
    if [[ "$script_name" == "$1" ]]; then
      local script_command=${script#*=}
      script_matches_cmd=$script_command
      return 0
    fi
  done
  return 1
}

function _preexec {
  if [[ ! -n $1 ]]; then
    return
  fi

  local cmd=${1%% *}
  if [[ -n $(command -v "$cmd") ]]; then
    return
  fi

  if [[ ! -n $(command -v npm) ]]; then
    echo 'pjshell: warning - npm not found'
    # TODO: unload hook?
    return
  fi

  if [[ -f "$PWD/package.json" ]]; then
    get_scripts "$cmd"
    script_found=$?
    if [[ script_found -eq 0 ]]; then
      echo "pjshell: Unknown command - falling back to npm-script: $cmd 👍"
      # TODO: trap and prevent original command from running
      eval "npm run $1"
    fi
  else
    return
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec _preexec
