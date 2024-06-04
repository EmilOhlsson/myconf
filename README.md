---
title: "Repo overview"
---

# My configuration
A small collection of common useful settings

## Setup
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
building your own, by following [building Neovim][building-neovim]

- Set up `local.vim`

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

<!-- Link table -->
[building-nvim]: docs/building-nvim.md

<!-- vim: set et ts=4 sw=4 ss=4 tw=100 : -->
