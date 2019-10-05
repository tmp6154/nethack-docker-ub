#!/bin/bash

TIMESTAMP=`date +%Y-%m-%d.%H:%M:%S`
LANG=en-US.UTF-8

if [ -z "$NO_FILTERM" ]
then
    FILTERM_CMD="filterm ascii-ascii cp437-utf8"
else
    FILTERM_CMD=""
fi

LAUNCH_CMD="$FILTERM_CMD ./nh/install/games/nethack"

mkdir -p /tmp/dumplog
mkdir -p ./nethack/save
touch ./nethack/record
touch ./nethack/perm
touch ./nethack/logfile
touch ./nethack/xlogfile

reset
stty sane
stty -icrnl
ttyrec ~/ttyrec/$(whoami)-$TIMESTAMP.ttyrec -e \
    "$LAUNCH_CMD"; ~/archivegame.sh; exit
