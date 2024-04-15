#!/usr/bin/env zsh

# TODO: set these but locally?
# set -o err_return
# set -o no_unset
# set -o pipefail

# local script_matches_cmd

# get_scripts <name_to_match>
function get_scripts {
  # echo "arg: $1"
  # (f) splits newlines
  local scripts=("${(f)$(jq -r '.scripts | to_entries[] | "\(.key)=\(.value)"' package.json)}")
  # TODO: just look for name with jq
  for script in $scripts; do
    local script_name=${script%%=*}
    if [[ "$script_name" == "$1" ]]; then
      # local script_command=${script#*=}
      # script_matches_cmd=$script_command
      return 0
    fi
  done
  return 1
}

function _pjshell {
  if [[ ! -n $1 ]]; then
    return
  fi

  local cmd=${1%% *}
  if [[ -n $(command -v "$cmd") ]]; then
    return
  fi


  if [[ ! -n $(command -v jq) ]]; then
    echo 'pjshell: warning - jq not found - is it installed?'
    echo 'disabling pjshell for this session'
    add-zsh-hook -d preexec _pjshell
    return
  fi
  if [[ ! -n $(command -v npm) ]]; then
    echo -e 'pjshell: warning - npm not found'
    echo 'Disabling pjshell for this session'
    add-zsh-hook -d preexec _pjshell
    return
  fi

  if [[ -f "$PWD/package.json" ]]; then
    get_scripts "$cmd"
    script_found=$?
    if [[ script_found -eq 0 ]]; then
      # verbose?
      # echo "pjshell: Unknown command… falling back to npm-script: $cmd 👍"
      echo "pjshell: falling back to npm-script: $cmd"
      pjs_dir="./.pjs"; local_pjs_dir="$pjs_dir:A"
      [[ -d "$local_pjs_dir" ]] || mkdir "$local_pjs_dir"
      exec_path="$local_pjs_dir/$1"
      [[ -f "$exec_path" ]] || echo "npm run $1" > "$exec_path" # TODO: What if this removed itself from the path too?
      chmod +x "$exec_path" # It may not be possible to chmod depending on security settings :\
      export -U PATH=$local_pjs_dir${PATH:+:$PATH} # TODO: Verify export always possible?
    fi
  else
    return
  fi
}

# TODO: add a hook to remove the path from the PATH

autoload -U add-zsh-hook
add-zsh-hook preexec _pjshell
