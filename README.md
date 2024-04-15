# pjshell - package.json script shell

Run your package.json scripts _without_ needing to call `npm run` explicitly:

```shell
# Traditional
❯ npm run my-script

> @pjshell/zsh@0.0.2 my-script
success!

# Convenient
❯ my-script
zsh: command not found: my-script
pjshell: falling back to npm-script: my-script

> @pjshell/zsh@0.0.2 my-script
success!

# Supports script-name variant convention
❯ lint:style
pjshell: falling back to npm-script: lint:style

# Supports passing args
❯ lint -- --format json
pjshell: falling back to npm-script: lint

```

This zsh plugin is for users who want to use pjshell globally on projects they do not own or without having to [use the pjshell package to persistently link a project's scripts](#to-do).

## Requirements

For now, [jq](https://jqlang.github.io/jq/) is used to parse package.json files
and must be installed. I might remove this requirement later…

## Installation

### [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#adding-a-new-plugin)

```sh
git clone https://github.com/binury/pjshell "$ZSH_CUSTOM/plugins/pjshell"
# Edit your .zshrc plugins list or...
echo "plugins+=(pjshell)" >> ~/.zshrc
```

### Manual

```sh
# Manual
git clone https://github.com/binury/pjshell pjshell && pushd $_;
cat <<PJ >> ~/.zshrc
# Load pjshell plugin
source $PWD/pjshell.zsh
PJ
popd;
```

## To-do

- [x] Suppress command-not-found error message if script matches
- [ ] Options for handling namespace conflicts (e.g., `test`)
- [ ] Facilitate installation through `npm i -g @pjshell/zsh`
- [ ] use pjshell to link the scripts per-project
