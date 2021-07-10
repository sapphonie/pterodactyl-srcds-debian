#!/bin/bash
cd /home/container || exit 1
sleep 1

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP

runbash()
{
    bash
}

runserver()
{
    # Replace Startup Variables
    MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
    echo -e ":/home/container$ ${MODIFIED_STARTUP}"

    # evil evil evil
    sudo -E -u container -- eval ${MODIFIED_STARTUP}
}

# run bash if we're running in a setup script, or if no startup command is provided.
# otherwise, run normal server logic
if [[ ${STARTUP} == bash ]] || [[ ! ${STARTUP} ]]; then
    runbash
else
    runserver
fi

