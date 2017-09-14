#!/bin/bash
##########################################################
##########################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

all_option=$(whiptail --title "G3 Tool" --radiolist "Please select the service type:" 15 60 2 \
"G3" "Take Action On G3 Instances" ON \
"WAS" "Take Action on WAS Services" OFF 3>&1 1>&2 2>&3)

status=$?
echo "G3 Main Commander: all_option=${all_option}"
echo "G3 Main Commander: status=${status}"

if [ ${status} == 0 ]; then	 
   if [ ${all_option} == "WAS" ]; then      
      ./wasActionSelection.sh      
   else
      ./g3ActionSelection.sh
   fi   
else
   echo "G3 Main Commander:: Cancelled!"
fi
