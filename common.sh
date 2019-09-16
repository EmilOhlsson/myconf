# This file should support both bash and zsh

function list-code-files() {
    find -type f \( \
        -iname 'sconstruct' -o \
        -iname 'sconscript' -o \
        -iname '*.cmake' -o \
        -iname '*.cpp' -o \
        -iname '*.hpp' -o \
        -iname '*.java' -o \
        -iname '*.rs' -o \
        -iname '*.json' -o \
        -iname '*.php' -o \
        -iname '*.py' -o \
        -iname '*.[chS]' -o \
        -iname 'Makefile' -o \
        -iname '*.mk' \
        \) -print0
}

function list-c-code-files() {
    find -type f \( \
        -name '*.cpp' -o \
        -name '*.hpp' -o \
        -name '*.[ch]' \
        \) -print0
}

function csym() {
    list-code-files | xargs -0 grep -ne "$1" | sed -e 's/:/ +/'
}

function ctodo() {
    csym 'TODO\|FIXME'
}

function csed() {
    list-code-files | xargs -0 sed -i -e "$1"
}

function cgadd() {
    list-code-files | xargs -0 git add
}

function cfmt() {
    list-c-code-files | xargs -0 clang-format -i
}

function csymdb() {
    find -name '*.[ch]' > cscope.files
    cscope -b -q
    ctags -R ./
}

alias vim='gvim -v'
alias rs232='minicom --color=on --noinit -b 115200 -D'
alias arm-dump='arm-none-eabi-objdump -xwdlSC'
alias native-dump='objdump -xwdlSC'

export PATH=${HOME}/.cargo/bin:$PATH
export PATH=${HOME}/.local/bin:$PATH
export PATH=${HOME}/local/bin:$PATH
