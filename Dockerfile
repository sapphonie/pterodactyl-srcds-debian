# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:20.10

LABEL       author="Pterodactyl Software" maintainer="support@pterodactyl.io"

ENV         DEBIAN_FRONTEND noninteractive
# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y tar curl gcc g++ lib32gcc-s1-amd64-cross libgcc1 libcurl4-gnutls-dev:i386 libcurl4:i386 libtinfo5 lib32z1 libstdc++6 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libreadline5 lib32ncurses-dev iproute2 gdb libsdl1.2debian libfontconfig telnet net-tools netcat libtcmalloc-minimal4 faketime:i386 locales libmariadb3 \
            && update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales \
            && useradd -m -d /home/container container
            #&& rm /etc/resolv.conf; echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf


USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
