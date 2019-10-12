#!/bin/bash

DUMPLOGDIR="/tmp/dumplog"

if [ -z "$(find $DUMPLOGDIR -type f)" ]; then
    exit 0
else
    echo "Detected new dumplog, archiving game"
    DUMPLOG=$(find $DUMPLOGDIR -type f | tail -1)
    GAMENAME=$(basename $DUMPLOG .log)
    mkdir -p ./dumps/$GAMENAME/dumplog
    mkdir -p ./dumps/$GAMENAME/ttyrec
    mv $DUMPLOG ./dumps/$GAMENAME/dumplog/
    mv ./ttyrec/* ./dumps/$GAMENAME/ttyrec/
    XZ_OPT=-9 tar -C ./dumps -cJf ./dumps/$GAMENAME.tar.xz $GAMENAME
    rm -rf ./dumps/$GAMENAME
    echo "Done"
fi
