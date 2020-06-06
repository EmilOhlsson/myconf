# If not running tmux, then start tmux
if [ "$TMUX" = "" ] && [ "$SSH_CLIENT" = "" ]
then
    exec tmux new-session
fi

# Path to oh-my-zsh installation.
export ZSH=$HOME/myconf/oh-my-zsh
export ZSH_CUSTOM=$HOME/myconf/zsh-custom

ZSH_THEME="candy"
HIST_STAMPS="yyyy-mm-dd"

source $ZSH/oh-my-zsh.sh
source $HOME/myconf/zsh-autosuggestions/zsh-autosuggestions.zsh

source $HOME/myconf/common.sh

export VISUAL=vim
export EDITOR="gvim -v"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6"
export RUST_SRC_PATH=$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/

eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)

unsetopt sharehistory

