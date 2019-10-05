# UltraBloxX's NetHack Distribution

A customizable docker image with cutting edge development snapshot of NetHack, painless support for IBMGraphics via filterm, ttyrec recording, dumplog collecting and support for customizations. Compatible and tested both on x86_64 and ARM (e.g. Raspberry Pi, etc.).

## Building your own docker NetHack image:

**1. Clone this repo to somewhere.**

`git clone https://github.com/tmp6154/nethack-docker-ub.git`

**2. Customize your installation.**

Most of customizable files are located in the **./conf** directory. Modify them to customize game compilation or preferences.

**conf/nh-pre.sh** - Script that is executed right after NetHack repository cloning, prior to compilation. By default, it just runs git checkout of the latest development branch of NetHack. If you want to do something within image before compilation, it should go there.

**patches** - Directory, containing the custom patch files to be applied atop the vanilla source tree. Drop your patches there.

**conf/nh-defines.sh** - Script that sets up compile-time options (runs after applying patches). If you want to change any build-time options, edit this script.

**conf/sysconf** - sysconf to be used for the game.

**conf/nethackrc** - User's .nethackrc with game preferences. Replace it with your .nethackrc, or edit included one to suit your needs.

**3. Build the image.**

To build the image, run following command in the repository directory.

`docker build -t nethack --no-cache --build-arg USER=<unixusername> .`

If you want to be asked for name on each game start, use "nethack" as user name, otherwise specify preferred name.

In case you want to disable IBMGraphics - you should also add following option before last argument:

`--build-arg NO_FILTERM=true`

Building could take some time (which is especially true for ARM platforms, because game is compiled from the sources).

**4. Run the game.**

You need to create three volumes for this image. This has to be done once.

    docker volume create playground
    docker volume create ttyrec
    docker volume create dumps

First volume is used to store NetHack's playground (which contains save files, etc.). Second volume holds ttyrec files for games in progress. Third volume contains archived dumps from ended games (containing session's ttyrecs and dumplogs).

Then, to run play the game, run the following command (be sure to put chosen username instead of placeholder).

    docker run --name nethack --rm -it -v=playground:/home/<unixusername>/nethack -v=ttyrec:/home/<unixusername>/ttyrec -v=dumps:/home/<unixusername>/dumps nethack

This would run a containerized NetHack. Container is autoremoved when it's stops, but data will be saved and persisted on the volumes. To continue the game, just run the above command once again.

### Scripts

This image also contains two bash scripts. It should not be necessary to modify these, but you're free to do so.

**startnh.sh** makes sure that required files and directories exists, sets up terminal to properly display the game and launches NetHack with ttyrec and filterm. This is an entrypoint of the image.

**archivegame.sh** is run after NetHack quits. This script tracks whether current game is ended by monitoring dumplog directory. If it detects a new dumplog, it would create a tar.xz archive, containing all ttyrecs and dumplog from finished game.

## License

![GPLv3](https://github.com/tmp6154/nethack-docker-ub/blob/master/img/gplv3.png?raw=true "GPLv3")
