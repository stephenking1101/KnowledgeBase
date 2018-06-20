#!/bin/bash
##########################################################
##########################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

source ../loadConfiguration.sh

was_option=$(whiptail --title "G3 Tool" --radiolist "Please select action for WAS cluster:" 15 60 3 \
"stop" "Stop cluster" ON \
"start" "Start cluster" OFF \
"restart" "Restart cluster" OFF 3>&1 1>&2 2>&3)

status=$?
echo "WAS Action Selection: status=${status}"

if [ ${status} == 0 ]; then	 
	 echo "WAS Action Selection: option=${was_option}"
   ./wasActionTrigger.sh ${was_option}
else
   echo "WAS Action Selection: Cancelled!"
   ./g3MainCommander.sh
fi