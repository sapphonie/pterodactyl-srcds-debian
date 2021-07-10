#!/bin/bash
cd /home/container || exit 1
sleep 1
# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP


# run bash if we're running in a setup script, otherwise, run normal server logic
[[ $1 =~ bash ]] && runbash || runserver

runbash()
{
    bash
}

runserver()
{
    # Replace Startup Variables
    MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
    echo -e ":/home/container$ ${MODIFIED_STARTUP}"

    # Run the Server
    eval ${MODIFIED_STARTUP}
}
