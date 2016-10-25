#!/bin/bash
# vim:set et ts=4 sw=4 ss=4:

REPODIR=$(readlink -e $(dirname $0))
RELEASE_FILE=/etc/os-release

function fedora_install() {
    sudo dnf install \
        redhat-lsb git gcc-c++ flex bison patch \
        artwiz-aleczapka-fontsi network-manager-applet \
        ncurses-devel tmux slock vim-enhanced vim-X11 \
        strace slock i3 firewall-config
    (\
        cd $HOME; \
        ln -s {$REPODIR/,.}tmux.conf; \
        ln -s {$REPODIR/,.}vimrc; \
        ln -s {$REPODIR/,.}vim; \
        echo "source $REPODIR/bashrc" >> .bashrc )
}

if [ ! -f $RELEASE_FILE ]
then
    echo "Release file not found"
    exit 1
fi

eval $(cat $RELEASE_FILE)

case "$ID" in
    "fedora")
        echo "Doing fedora install"
        fedora_install
        ;;

    "debian")
        echo "Doing debian install"
        ;;

    *)
        echo "Unknown distribution"
        ;;
esac
