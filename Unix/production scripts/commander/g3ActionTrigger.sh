#!/bin/bash
##########################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

action_option=$1
Commander_Dir=/G3/apps/

echo "G3 Commander: action option=${action_option}"

source ../loadConfiguration.sh

function stop-automation
{
  ${Commander_Dir}/automation/init.d/automation stop
}

function start-automation
{
  ${Commander_Dir}/automation/init.d/automation start
}

function restart-automation
{
  stop-automation
  start-automation
}

function stop-artifact-management
{
  ${Commander_Dir}/artifact-management/init.d/artifact-management-service stop
}

function start-artifact-management
{
  ${Commander_Dir}/artifact-management/init.d/artifact-management-service start
}

function restart-artifact-management
{
  stop-artifact-management
  start-artifact-management
}

function stop-command-execution
{
  ${Commander_Dir}/command-execution/init.d/command-execution stop
}

function start-command-execution
{
  ${Commander_Dir}/command-execution/init.d/command-execution start
}

function restart-command-execution
{
  stop-command-execution
  start-command-execution
}

function stop-file-transport
{
  ${Commander_Dir}/file-transport/init.d/file-transport-service stop
}

function start-file-transport
{
  ${Commander_Dir}/file-transport/init.d/file-transport-service start
}

function restart-file-transport
{
  stop-file-transport
  start-file-transport
}

function stop-scheduler
{
  ${Commander_Dir}/scheduler/init.d/scheduler-service stop
}

function start-scheduler
{
  ${Commander_Dir}/scheduler/init.d/scheduler-service start
}

function restart-scheduler
{
  stop-scheduler
  start-scheduler
}

function stop-shared
{
  ${Commander_Dir}/shared/init.d/shared-assembly stop
}

function start-shared
{
  ${Commander_Dir}/shared/init.d/shared-assembly start 
}

function restart-shared
{
  stop-shared
  start-shared
}

function stop-workflow
{
  ${Commander_Dir}/workflow/init.d/workflow-service stop 
}

function start-workflow
{
  ${Commander_Dir}/workflow/init.d/workflow-service start 
}

function restart-workflow
{
  stop-workflow
  start-workflow
}

function stop-security
{
  ${Commander_Dir}/security/init.d/security-service stop 
}

function start-security
{
  ${Commander_Dir}/security/init.d/security-service start 
}

function restart-security
{
  stop-security
  start-security
}

function stop-all
{
  stop-security
  stop-workflow
  stop-shared
  stop-scheduler
  stop-file-transport
  stop-command-execution
  stop-artifact-management
  stop-automation
}

function start-all
{
  start-automation
  start-artifact-management
  start-command-execution
  start-file-transport
  start-scheduler
  start-shared
  start-workflow
  start-security
}

function restart-all
{
	stop-all
	start-all
}

declare -A SERVICES

#SERVICES["properties-file"]='G3 properties-files service'
SERVICES["automation"]='G3 automation service'
SERVICES["artifact-management"]='G3 artifact-management service'
SERVICES["command-execution"]='G3 command-execution service'
SERVICES["file-transport"]='G3 file-transport service'
SERVICES["scheduler"]='G3 scheduler service'
SERVICES["shared"]='G3 shared service'
SERVICES["workflow"]='G3 workflow service'
SERVICES["security"]='G3 security service'
SERVICES["all"]='G3 all services'


g3_option=$(whiptail --title "G3 Tool" --radiolist "Please select G3 service:" 20 80 9 \
"automation" "${SERVICES['automation']}" ON \
"artifact-management" "${SERVICES['artifact-management']}" OFF \
"command-execution" "${SERVICES['command-execution']}" OFF \
"file-transport" "${SERVICES['file-transport']}" OFF \
"scheduler" "${SERVICES['scheduler']}" OFF \
"shared" "${SERVICES['shared']}" OFF \
"workflow" "${SERVICES['workflow']}" OFF \
"security" "${SERVICES['security']}" OFF \
"all" "${SERVICES['all']}" OFF 3>&1 1>&2 2>&3)

status=$?

echo "G3 Action Trigger: option=${g3_option}"
echo "G3 Action Trigger: status=${status}"


if [ ${status} == 0 ]; then
	 G3_OPTION_DESC=${SERVICES[${g3_option}]}
   if (whiptail --title "Confirmation On Your Action" --yesno "You are trying to ${action_option} on ${G3_OPTION_DESC}." 10 60) then
      echo "Trying to execute action: ${action_option} on ${G3_OPTION_DESC}"
      todo_cmd=${action_option}-${g3_option}
      echo "Calling method: ${todo_cmd}"
      ${todo_cmd}
      echo "G3 Commander: Action completed"
	 else
      echo "G3 Commander: Exit to select page."
      ./g3ActionSelection.sh
   fi   
else
   echo "G3 Commander: Cancelled!"
   ./g3MainCommander.sh
fi

