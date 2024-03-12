# pjshell - package.json script shell

Run your package.json scripts _without_ needing to call `p/npm run` explicitly:

```shell
# Traditional
❯ npm run my-script

> @pjshell/zsh@0.0.2 my-script
success!

# Convenient
❯ my-script
zsh: command not found: my-script
pjshell: Unknown command - falling back to npm-script: my-script 👍

> @pjshell/zsh@0.0.2 my-script
success!

# Supports script-name variant convention
❯ lint:style
pjshell: Unknown command - falling back to npm-script: lint:style 👍

# Supports passing flags
❯ lint -- --format json
pjshell: Unknown command - falling back to npm-script: lint 👍

```

## Requirements

For now, [jq](https://jqlang.github.io/jq/) is used to parse package.json files
and must be installed. I might remove this requirement later…

## Installation

```sh
# Manual
git clone https://github.com/binury/npm-script-shell-plugin pjshell && pushd $_;
cat <<PJ >> ~/.zshrc
# Load pjshell plugin
source $PWD/pjshell.zsh
PJ
popd;

# Plugin managers (e.g., antidote)
antidote bundle binury/npm-script-shell-plugin
```

## To-do

- [ ] Suppress command-not-found error message if script matches
- [ ] Options for handling namespace conflicts (e.g., `test`)
- [ ] Facilitate installation through `npm i -g @pjshell/zsh`
