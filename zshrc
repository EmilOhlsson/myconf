# If not running tmux, then start tmux
if [ "$TMUX" = "" ] && [ "$SSH_CLIENT" = "" ] && [ "$TMUX_SKIP" = "" ]
then
    exec tmux new-session
fi

# Make sure there is some form of background theme
[ "$BACKGROUND" = "" ] && export BACKGROUND='dark'

# Path to oh-my-zsh installation.
export ZSH=$HOME/myconf/oh-my-zsh
export ZSH_CUSTOM=$HOME/myconf/zsh-custom

ZSH_THEME="candy-solarized"
HIST_STAMPS="yyyy-mm-dd"
DISABLE_AUTO_TITLE="true"
plugins=(zsh-autosuggestions zsh-syntax-highlighting direnv)

source $ZSH/oh-my-zsh.sh

source $HOME/myconf/common.sh

setopt emacs
setopt inc_append_history
setopt hist_save_no_dups
setopt extendedglob

export VISUAL=nvim
export EDITOR=nvim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add support for searching backward in history based on prefix
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# Create user defined widet
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^E" end-of-line
bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey "^A" beginning-of-line
bindkey "^X^E" edit-command-line
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

ZSH_HIGHLIGHT_STYLES[comment]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=red'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=red'

if [ "$BACKGROUND" = light ]
then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#d78700'
else
    eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)
fi

# vim: set et ts=4 sw=4 ss=4:
