# vim: set et tw=80 ts=4 sw=4 ss=4 :

function reset_prompt()
{
    export PS1="\u@\h:\W \$"
    export PS2=">"

    # set color
    export PS1="\[$(tput setaf 6)\]$PS1\[$(tput sgr0)\]"
    export PS2="\[$(tput setaf 6)\]$PS2\[$(tput sgr0)\]"
    # invert colors
    export PS1="\[$(tput rev)\]$PS1\[$(tput sgr0)\] "
    export PS2="\[$(tput rev)\]$PS2\[$(tput sgr0)\] "
}

source $HOME/myconf/common.sh

export VISUAL=vim
export EDITOR="gvim -v"

eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)

case $- in
    *i*)
        # Interactive shell
        reset_prompt
        ;;
esac
