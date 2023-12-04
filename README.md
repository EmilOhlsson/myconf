A small collection of common useful settings

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
```
dnf groupinstall "Development tools"
ssh-keygen -t ed25519
dnf install kitty sway tmux git 
```

## CPU governors
```
cpupower frequency-info -o proc
cpupower frequency-set -g performance
```
