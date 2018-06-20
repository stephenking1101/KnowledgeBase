#!/bin/bash
##########################################################
##########################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

source ../loadConfiguration.sh

option=$(whiptail --title "G3 Tool" --radiolist "Please select action for G3 service:" 15 60 3 \
"stop" "Stop Service" ON \
"start" "Start Service" OFF \
"restart" "Restart Service" OFF 3>&1 1>&2 2>&3)

status=$?
echo "G3 Action Selection:  status=${status}"

if [ ${status} == 0 ]; then	 
	 echo "G3 Action Selection:  option=${option}"
   ./g3ActionTrigger.sh ${option}
else
   echo "G3 Action Selection: Cancelled!"
   ./g3MainCommander.sh
fi