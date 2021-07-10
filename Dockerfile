# ----------------------------------
# Pterodactyl Panel Dockerfile
# Environment: Source Engine
# ----------------------------------
FROM        debian:buster-slim

LABEL       author="Pterodactyl Software - edited by sapphonie" maintainer="sappho@sappho.io"

ENV         DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            # programs
            && apt-get install -y --no-install-recommends curl net-tools iproute2 faketime:i386 locales \
            lib32gcc1-amd64-cross libgcc1 libcurl4-gnutls-dev:i386 libcurl4:i386 libtinfo5 lib32z1 libstdc++6 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libreadline5 lib32ncurses-dev libsdl1.2-dev libfontconfig1 libtcmalloc-minimal4 libmariadb3 \
            && update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales \
            && useradd -U -m -d /home/container container \
            # todo, do we need this?
            && update-ca-certificates
            # dns fuckery, commented for now
            #&& rm /etc/resolv.conf; echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf
            # bump


USER        container:container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
