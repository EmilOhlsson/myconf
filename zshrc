# Path to oh-my-zsh installation.
export ZSH=$HOME/myconf/oh-my-zsh

ZSH_THEME="bira"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias vim='gvim -v'

export TFTPBOOT=/srv/tftp/tftpboot
export NFSROOT=/srv/nfs/rootfs

eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)

function list-code-files() {
    find -type f \( \
        -name '*.cpp' -o \
        -name '*.java' -o \
        -name '*.php' -o \
        -name '*.[chS]' -o \
        -name 'Makefile' -o \
        -name '*.mk' \
        \) -print0
}

function csym() {
    list-code-files | xargs -0 grep -ne "$1"
}

function csymdb() {
    find -name '*.[ch]' > cscope.files
    cscope -b -q
    ctags -R ./
}
