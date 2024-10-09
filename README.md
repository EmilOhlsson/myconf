# My configuration
A small collection of common useful settings

## Setup
Install

Fedora:
```
sudo dnf install git zsh gettext
```

Debian:
```
sudo apt install git zsh gettext
```


Install bashrc by sourcing `bashrc`

Install Xresources by adding
```
#include "myconf/Xdefaults"
```

to your X configuration file
```
! vim:set et ts=4 sw=4 ss=4:
#include "myconf/Xresources"
URxvt*font: xft:lime.se:size=8
```

### Neovim
In case a recent enough Neovim version isn't available, then it's worth
building your own, by following [building Neovim](docs/building-neovim.md)

- Set up `local.vim`

## bat
Bat is like `cat`, but it can do syntax highlighting. It's worth setting color scheme to 
something that works with your background colors.

```
$ cat $(bat --config-file)
--theme=GitHub
```

## Direnv
Direnv is tool that sources the `.envrc` when entering a directory. This is useful to set up
directory local environments

Make sure direnv is loaded by shell configuration. For OMZ this can be done by making sure the
direnv plugin is loaded. To use direnv do the following steps
```sh
echo 'VARIABLE=value' >> .envrc
direnv allow .
pushd
popd
```

## Useful tree-sitter queries
```scheme
((comment) @todo
 (#match? @todo "TODO"))

; @declaration.identifier
(declaration
  declarator: (identifier) @declaration.identifier)
(init_declarator
  declarator: (identifier) @declaration.identifier)
(reference_declarator 
  (identifier) @declaration.identifier)

; class.declaration
(class_specifier
  name: (type_identifier) @class.declaration)
(struct_specifier
  name: (type_identifier) @class.declaration)
```

## Packages
```sh
dnf groupinstall "Development tools"
ssh-keygen -t ed25519
dnf install kitty sway tmux git 
```

## CPU governors
```sh
cpupower frequency-info -o proc
cpupower frequency-set -g performance
```

## Fedora mount
```
udiskctl mount -b /dev/device
udiskctl unmount -b /dev/device
```

## firewall
```
firewall-cmd --list-all
firewall-cmd --add-port=8080/tcp
firewall-cmd --permanent --add-service=mdns
```

## Podman
```
podman run --rm -it -v $PWD:$PWD:U,Z --entry-point=/bin/bash fedora:latest
```

<!-- vim: set et ts=2 sw=2 ss=2 tw=100 : -->
