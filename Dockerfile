FROM debian:bullseye

LABEL version="1.0"
LABEL description="UltraBloxX's NetHack Distribution"
LABEL maintainer="tmp6154@yandex.ru"

ARG USER=ultrabloxx
ARG NO_FILTERM=
ENV USER=$USER
ENV NO_FILTERM=$NO_FILTERM

# Install build tools

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install git \
    gcc \
    make \
    build-essential \
    konwert \
    ttyrec \
    curl \
    groff-base \
    bsdmainutils \
    ncurses-dev -y

# Make a new user

RUN groupadd -g 1000 $USER && useradd -u 1000 -g $USER $USER && \
    mkdir -p /home/$USER && chown $USER:$USER /home/$USER && \
    chmod 755 /home/$USER
USER $USER
WORKDIR /home/$USER

# Build NetHack from official repo

COPY --chown=1000:1000 ./conf/nh-pre.sh ./
COPY --chown=1000:1000 ./patches ./patches
COPY --chown=1000:1000 ./conf/nh-defines.sh ./
RUN git clone https://github.com/NetHack/NetHack.git && \
    mv ./nh-pre.sh ./nh-defines.sh ./patches ./NetHack && \
    cd NetHack && sh ./nh-pre.sh && for f in ./patches/*.patch; do \
    [ -e "$f" ] || continue; git apply --3way $f; done && \
    sh ./nh-defines.sh && cd sys/unix && \
    sh setup.sh hints/linux && cd ../.. && make fetch-lua && \
    make -j$((`nproc`+1)) && make install && \
    cd .. && rm -rf NetHack

# Setup scripts

RUN mkdir ./nethack && mkdir ./dumps && mkdir ./ttyrec
COPY --chown=1000:1000 ./archivegame.sh ./archivegame.sh
COPY --chown=1000:1000 ./startnh.sh ./startnh.sh
COPY --chown=1000:1000 ./conf/sysconf ./nh/install/games/lib/nethackdir/sysconf
COPY --chown=1000:1000 ./conf/nethackrc ./.nethackrc

# Define launch command

CMD ["/bin/bash", "./startnh.sh"]
