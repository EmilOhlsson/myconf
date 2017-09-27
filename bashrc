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

function quick-review() {
    git diff master | grep -e '^+' | grep -n \
        -e '//' \
        -e '/\*' \
        -e '#\s*if\s*0'
}

alias rs232='minicom --color=on --noinit -b 115200 -D'

alias vim='gvim -v'

alias todo='vim ~/.todo.md'
alias notes='vim ~/.notes.md'

export TFTPBOOT=/srv/tftp/tftpboot
export NFSROOT=/srv/nfs/rootfs

export VISUAL=vim
export EDITOR="gvim -v"

export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

eval $(dircolors -b $HOME/myconf/LS_COLORS/LS_COLORS)

case $- in
    *i*)
        # Interactive shell
        reset_prompt
        ;;
esac
