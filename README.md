# pjshell - package.json script shell

Run your package.json scripts _without_ needing to call `npm run` explicitly:

```shell
# Traditional
❯ npm run my-script

> @pjshell/zsh@0.0.2 my-script
success!

# Convenient
❯ my-script
pjshell: falling back to npm-script: my-script

> @pjshell/zsh@0.0.2 my-script
success!

# Supports script-name variant convention
❯ lint:style
pjshell: falling back to npm-script: lint:style

# Supports passing args naturally
❯ lint --format json
pjshell: falling back to npm-script: lint

```

This zsh plugin is for users who want to use pjshell globally on projects they do not own or without having to [use the pjshell package to persistently link a project's scripts](#to-do).[^0]

## Requirements

For now, [jq](https://jqlang.github.io/jq/) is used to parse package.json files
and must be installed. I might remove this requirement later…

## Installation

For either method, the relative path to the temporary `.pjs` directory should be included in your $PATH (as early as possible). E.g.: `export -U PATH=./.pjs${PATH:+:$PATH}`

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

- [ ] use pjshell to link the scripts per-project
- [ ] Options for handling namespace conflicts (e.g., `test`)
- [ ] Facilitate installation through `npm i -g @pjshell/zsh`
- [x] Suppress command-not-found error message if script matches

[^0]:  This plugin will create an emphemeral `.pjs` directory containing your scripts as executable files whenever you run a (non-existent) command that matches one of the scripts in the working directory's package.json. As soon as the command runs, the directory is torn down and removed.
