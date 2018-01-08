# Path to oh-my-zsh installation.
export ZSH=$HOME/myconf/oh-my-zsh

ZSH_THEME="bira"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git cargo tmux docker fedora rust)

source $ZSH/oh-my-zsh.sh

alias vim='gvim -v'
alias rs232='minicom --color=on --noinit -b 115200 -D'

export PATH=${HOME}/.cargo/bin:$PATH
export PATH=${HOME}/local/bin:$PATH
export TFTPBOOT=/srv/tftp/tftpboot
export NFSROOT=/srv/nfs/rootfs
export VISUAL=vim
export EDITOR="gvim -v"
export TERMINAL="xfce4-terminal"

eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)

function list-code-files() {
    find -type f \( \
        -name '*.cpp' -o \
        -name '*.java' -o \
        -name '*.json' -o \
        -name '*.php' -o \
        -name '*.[chS]' -o \
        -name 'Makefile' -o \
        -name '*.mk' \
        \) -print0
}

function csym() {
    list-code-files | xargs -0 grep -ne "$1"
}

function csed() {
    list-code-files | xargs -0 sed -i -e "$1"
}

function csymdb() {
    find -name '*.[ch]' > cscope.files
    cscope -b -q
    ctags -R ./
}

unsetopt sharehistory

# If not running tmux, then start tmux
if [ "$TMUX" = "" ]
then
    tmux new-session
fi
