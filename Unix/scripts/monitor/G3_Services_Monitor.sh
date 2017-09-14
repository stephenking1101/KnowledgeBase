#!/bin/bash
#
# This shell script is used for monitor the memory usage of G3 services
#
################################################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

declare -A SERVICES

SERVICES["automation"]='G3 automation service'
SERVICES["artifact-management"]='G3 artifact-management service'
SERVICES["command-execution"]='G3 command-execution service'
SERVICES["file-transport"]='G3 file-transport service'
SERVICES["scheduler"]='G3 scheduler service'
SERVICES["shared"]='G3 shared service'
SERVICES["workflow"]='G3 workflow service'
SERVICES["security"]='G3 security service'
SERVICES["all"]='G3 all services'

option=$(whiptail --title "G3 Monitor Tool" --radiolist "Please select G3 service(s) to monitor:" 23 83 10 \
"all" "${SERVICES['all']}" ON \
"automation" "${SERVICES['automation']}" OFF \
"artifact-management" "${SERVICES['artifact-management']}" OFF \
"command-execution" "${SERVICES['command-execution']}" OFF \
"file-transport" "${SERVICES['file-transport']}" OFF \
"scheduler" "${SERVICES['scheduler']}" OFF \
"shared" "${SERVICES['shared']}" OFF \
"workflow" "${SERVICES['workflow']}" OFF \
"security" "${SERVICES['security']}" OFF \
 3>&1 1>&2 2>&3)

status=$?
echo "You want to monitor [${option}]..."


if [ ${status} -ne 0 ]; then
   echo "G3 Monitor Commander: Cancelled!"
   exit 255
fi

if [ ${option} = "all" ]; then
   ./Monitor_Impl.sh automation &
   ./Monitor_Impl.sh artifact-management &
   ./Monitor_Impl.sh command-execution &
   ./Monitor_Impl.sh file-transport &
   ./Monitor_Impl.sh scheduler &
   ./Monitor_Impl.sh shared &
   ./Monitor_Impl.sh workflow &
   ./Monitor_Impl.sh security &
   echo "G3 Monitor Commander: all!"

else
   ./Monitor_Impl.sh ${option} &
   echo "G3 Monitor Commander: [${option}]"
fi

echo "G3 Monitor Commander: End."

