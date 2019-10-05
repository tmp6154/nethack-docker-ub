#!/bin/bash

echo 'CFLAGS+=-DEDIT_GETLIN' >> ./sys/unix/hints/linux
echo 'CFLAGS+=-DAUTOSAVE' >> ./sys/unix/hints/linux
echo 'CFLAGS+=-DSCORE_ON_BOTL' >> ./sys/unix/hints/linux
echo 'CFLAGS+=-DDUMPLOG_FILE=\"/tmp/dumplog/nh%v.%n.%d.log\"' >> ./sys/unix/hints/linux
echo 'CFLAGS+=-DVAR_PLAYGROUND=\"'$HOME'/nethack\"' >> ./sys/unix/hints/linux
