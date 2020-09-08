#!/bin/bash
cd /home/container
sleep 1
# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\n"
    echo -e "Using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

## if auto_update is not set or to 1 update
if [  -z ${AUTO_UPDATE} ] || [ ${AUTO_UPDATE} == 1 ]; then 
    # Update Source Server
    if [ ! -z ${SRCDS_APPID} ]; then
        if [ ! -z ${HLDS_GAME} ]; then
            ./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH}  +force_install_dir /home/container +app_update ${SRCDS_APPID} +app_set_config 90 mod ${HLDS_GAME} +quit
        elif [ ! -z ${SRCDS_BETAID} ]; then
            if [ ! -z ${SRCDS_BETAPASS} ]; then
                ./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH}  +force_install_dir /home/container +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} -betapassword ${SRCDS_BETAPASS} +quit
            else
                ./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH}  +force_install_dir /home/container +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} +quit
            fi
        else
            ./steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH}  +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
        fi
    else
        echo -e "No appid set. Starting Server"
    fi

else
    echo -e "Not updating game server as auto update was set to 0. Starting Server"
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}