# Path to oh-my-zsh installation.
export ZSH=$HOME/myconf/oh-my-zsh
export ZSH_CUSTOM=$HOME/myconf/zsh-custom

ZSH_THEME="bira-nogit"
HIST_STAMPS="yyyy-mm-dd"

plugins=(tmux docker rust)

source $ZSH/oh-my-zsh.sh
source $HOME/myconf/zsh-autosuggestions/zsh-autosuggestions.zsh

alias vim='gvim -v'
alias rs232='minicom --color=on --noinit -b 115200 -D'

export PATH=${HOME}/.cargo/bin:$PATH
export PATH=${HOME}/local/bin:$PATH
export TFTPBOOT=/srv/tftp/tftpboot
export NFSROOT=/srv/nfs/rootfs
export VISUAL=vim
export EDITOR="gvim -v"
export TERMINAL="xfce4-terminal"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6"
export RUST_SRC_PATH=$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/

eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)

function list-code-files() {
    find -type f \( \
        -name '*.cpp' -o \
        -name '*.java' -o \
        -name '*.rs' -o \
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
if [ "$TMUX" = "" ] && [ "$SSH_CLIENT" = "" ]
then
    tmux new-session
fi