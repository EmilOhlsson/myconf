# This file should support both bash and zsh

function list-code-files() {
    find -type f \( \
        -name '*.cpp' -o \
        -name '*.hpp' -o \
        -name '*.java' -o \
        -name '*.rs' -o \
        -name '*.json' -o \
        -name '*.php' -o \
        -name '*.py' -o \
        -name '*.[chS]' -o \
        -name 'Makefile' -o \
        -name '*.mk' \
        \) -print0
}

function csym() {
    list-code-files | xargs -0 grep -ne "$1" | sed -e 's/:/ +/'
}

function csed() {
    list-code-files | xargs -0 sed -i -e "$1"
}

function csymdb() {
    find -name '*.[ch]' > cscope.files
    cscope -b -q
    ctags -R ./
}

alias vim='gvim -v'
alias rs232='minicom --color=on --noinit -b 115200 -D'

export PATH=${HOME}/.cargo/bin:$PATH
export PATH=${HOME}/.local/bin:$PATH
export PATH=${HOME}/local/bin:$PATH
