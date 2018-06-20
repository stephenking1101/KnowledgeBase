#!/bin/bash
##########################################################
##########################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

action_option=$1

function restart-cluster {
  sudo -u wasadm /home/${1}/iDeploy/iDeploy-lite-4.0/scripts/iRestart-lite.sh ~/iDeploy/iDeploy-lite-4.0 ${4} '-conntype SOAP' "--envkey=${2}"_"${3} --topology=cluster" '--wasHome=/opt/WebSphere85/AppServer --dmgrProfilePath=/opt/WebSphere85/profiles/dmgrprofile' '--clusterTimeout=3600 --sleepDelay=30'
}

function stop-cluster
{
  sudo -u wasadm /home/${1}/iDeploy/iDeploy-lite-4.0/scripts/iStop-lite.sh ~/iDeploy/iDeploy-lite-4.0 ${4} '-conntype SOAP' "--envkey=${2}"_"${3} --topology=cluster" '--wasHome=/opt/WebSphere85/AppServer --dmgrProfilePath=/opt/WebSphere85/profiles/dmgrprofile' '--clusterTimeout=3600 --sleepDelay=30'
}

function start-cluster
{
  sudo -u wasadm /home/${1}/iDeploy/iDeploy-lite-4.0/scripts/iStart-lite.sh ~/iDeploy/iDeploy-lite-4.0 ${4} '-conntype SOAP' "--envkey=${2}"_"${3} --topology=cluster" '--wasHome=/opt/WebSphere85/AppServer --dmgrProfilePath=/opt/WebSphere85/profiles/dmgrprofile' '--clusterTimeout=3600 --sleepDelay=30'
}

source ../loadConfiguration.sh

declare -A OPTIONS

OPTIONS["g3"]="G3 Web & API cluster"
OPTIONS["ccm"]="CCM cluster"
OPTIONS["jts"]="JTS cluster"
OPTIONS["all"]="ALL cluster (G3/CCM/JTS)"

function restart-cluster {
  sudo -u wasadm /home/${1}/iDeploy/iDeploy-lite-4.0/scripts/iRestart-lite.sh ~/iDeploy/iDeploy-lite-4.0 ${4} '-conntype SOAP' "--envkey=${2}"_"${3} --topology=cluster" '--wasHome=/opt/WebSphere85/AppServer --dmgrProfilePath=/opt/WebSphere85/profiles/dmgrprofile' '--clusterTimeout=3600 --sleepDelay=30'
}

function stop-cluster
{
  sudo -u wasadm /home/${1}/iDeploy/iDeploy-lite-4.0/scripts/iStop-lite.sh ~/iDeploy/iDeploy-lite-4.0 ${4} '-conntype SOAP' "--envkey=${2}"_"${3} --topology=cluster" '--wasHome=/opt/WebSphere85/AppServer --dmgrProfilePath=/opt/WebSphere85/profiles/dmgrprofile' '--clusterTimeout=3600 --sleepDelay=30'
}

function start-cluster
{
  sudo -u wasadm /home/${1}/iDeploy/iDeploy-lite-4.0/scripts/iStart-lite.sh ~/iDeploy/iDeploy-lite-4.0 ${4} '-conntype SOAP' "--envkey=${2}"_"${3} --topology=cluster" '--wasHome=/opt/WebSphere85/AppServer --dmgrProfilePath=/opt/WebSphere85/profiles/dmgrprofile' '--clusterTimeout=3600 --sleepDelay=30'
}

function stop-g3
(
	stop-cluster $user $hostname ${wasServers["g3"]} ${wasClusters["g3"]}
)

function stop-ccm
(
	stop-cluster $user $hostname ${wasServers["ccm"]} ${wasClusters["ccm"]}
)

function stop-jts
(
	stop-cluster $user $hostname ${wasServers["jts"]} ${wasClusters["jts"]}
)

function stop-all
(
      stop-cluster $user $hostname ${wasServers["g3"]} ${wasClusters["g3"]}
      stop-cluster $user $hostname ${wasServers["ccm"]} ${wasClusters["ccm"]}
      stop-cluster $user $hostname ${wasServers["jts"]} ${wasClusters["jts"]}
)

function start-g3
(
	start-cluster $user $hostname ${wasServers["g3"]} ${wasClusters["g3"]}  
)

function start-ccm
(
	start-cluster $user $hostname ${wasServers["ccm"]} ${wasClusters["ccm"]}  
)

function start-jts
(
	start-cluster $user $hostname ${wasServers["jts"]} ${wasClusters["jts"]}  
)

function start-all
(
	start-cluster $user $hostname ${wasServers["jts"]} ${wasClusters["jts"]}  
	start-cluster $user $hostname ${wasServers["ccm"]} ${wasClusters["ccm"]}  
	start-cluster $user $hostname ${wasServers["g3"]} ${wasClusters["g3"]}  
)

function restart-g3
(
	restart-cluster $user $hostname ${wasServers["g3"]} ${wasClusters["g3"]}  
)

function restart-ccm
(
	restart-cluster $user $hostname ${wasServers["ccm"]} ${wasClusters["ccm"]}  
)

function restart-jts
(
	restart-cluster $user $hostname ${wasServers["jts"]} ${wasClusters["jts"]}  
)

function restart-all
(
	stop-g3
	stop-ccm
	stop-jts
	start-jts
	start-ccm
	start-g3
)

option=$(whiptail --title "G3 Tool" --radiolist "Please select your action:" 15 80 4 \
"g3" "${OPTIONS['g3']}" ON \
"ccm" "${OPTIONS['ccm']}" OFF \
"jts" "${OPTIONS['jts']}" OFF \
"all" "${OPTIONS['all']}" OFF 3>&1 1>&2 2>&3)

status=$?

echo "WAS Action Trigger: option=${option}"
echo "WAS Action Trigger: status=${status}"

if [ ${status} == 0 ]; then
	 OPTION_DESC=${OPTIONS[${option}]}
   if (whiptail --title "Confirmation On Your Action" --yesno "You are trying to ${action_option} on ${OPTION_DESC}." 10 60) then
      echo "WAS Action Trigger: Trying to execute action: ${action_option} on ${OPTION_DESC}"
      todo_cmd=${action_option}-${option}
      echo "WAS Action Trigger: calling method ${todo_cmd}"
      ${todo_cmd}
      echo "WAS Action Trigger: Action completed"
	 else
      echo "WAS Action Trigger: Exit to select page."            
      ./wasActionSelection.sh
   fi   
else
   echo "WAS Action Trigger: Cancelled!"
   ./g3MainCommander.sh
fi

