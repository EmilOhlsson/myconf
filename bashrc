function reset_prompt()
{
	export PS1="\u@\h:\W \$"
	export PS2=">"

	## Suitable for black background
	# export PS1="\[$(tput setaf 6)\]$PS1\[$(tput sgr0)\] "
	# export PS2="\[$(tput setaf 6)\]$PS2\[$(tput sgr0)\] "

	## Suitable for light yellow backgroudn ##
	# set color
	export PS1="\[$(tput setaf 6)\]$PS1\[$(tput sgr0)\]"
	export PS2="\[$(tput setaf 6)\]$PS2\[$(tput sgr0)\]"
	# invert colors
	export PS1="\[$(tput rev)\]$PS1\[$(tput sgr0)\] "
	export PS2="\[$(tput rev)\]$PS2\[$(tput sgr0)\] "
}

function csym() {
	find  \( -name "*.cpp" -o -name "*.java" -o -name "*.php" -o -name "*.[chS]" \) -print0 | xargs -0 grep -ne "$1"
}

function todo() {
	find  \( -name '*.c' -or -name '*.cpp' -or -name '*.h' \) -print0 | xargs -0 grep -ne 'TODO\|FIXME'
}

function trash() {
	DATE=$(date "+%Y-%m-%d")
	TRASH_DIR="$HOME/trash/$DATE"
	[ -d "$TRASH_DIR" ] || mkdir "$TRASH_DIR"
	mv $* "$TRASH_DIR"
}

alias rs232='minicom --color=on --noinit -b 115200 -D'

alias vim='gvim -v'

alias todo='vim ~/.todo.txt'

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

set -o vi
