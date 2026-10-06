# ----------------------------------
# Pterodactyl Panel Dockerfile
# Environment: Source Engine
# ----------------------------------
FROM        debian:trixie-slim

LABEL       author="Pterodactyl Software - edited by sapphonie" maintainer="sappho@sappho.io"

ENV         DEBIAN_FRONTEND=noninteractive
ENV         TERM=screen

# Upgrade our base system first
RUN         tput setaf 2; echo "apt-get Upgrading base image..."; tput sgr0; \
            apt-get update \
            && apt-get upgrade -y --no-install-recommends

# from postgressql - set up en_US.UTF8 locale so srcds doesn't whine
# https://github.com/docker-library/postgres/blob/69bc540ecfffecce72d49fa7e4a46680350037f9/9.6/Dockerfile#L21-L24
RUN         tput setaf 2; echo "Setting en_US.UTF8 locale..."; tput sgr0; \
            apt-get update \
            && apt-get install -y locales \
            && rm -rf /var/lib/apt/lists/* \
            && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV         LANG=en_US.utf8

# install deps
RUN         tput setaf 2; echo "Installing dependencies..."; tput sgr0; \
            dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get install -y --no-install-recommends \
            # needed for ip route stuff in entrypoint.sh
            net-tools iproute2 \
            # TF2 Wiki says these are required
            # (trixie dropped libncurses5/libtinfo5, so we install the v6 libs and symlink below)
            lib32z1 libncurses6:i386 libbz2-1.0:i386 lib32gcc-s1 lib32stdc++6 libtinfo6:i386 libcurl3t64-gnutls:i386 \
            # needed for some sourcemod extensions
            curl libcurl4t64:i386 \
            # helpful tools
            python3 valgrind gdb \
            # needed for steamcmd
            ca-certificates \
            && rm -rf /var/lib/apt/lists/* \
            # srcds and friends still look for the .so.5 sonames
            && ln -sf libtinfo.so.6 /usr/lib/i386-linux-gnu/libtinfo.so.5 \
            && ln -sf libncurses.so.6 /usr/lib/i386-linux-gnu/libncurses.so.5

# set up our container user
RUN         tput setaf 2; echo "Creating container user..."; tput sgr0; \
            useradd -U -m -d /home/container -s /bin/bash container

RUN         tput setaf 2; echo "Done!"; tput sgr0;

USER        container:container
ENV         HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
