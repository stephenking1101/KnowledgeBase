#!/bin/bash
#
# This shell script is used for monitor the memory usage of G3 sharedservice
#
########################################################################

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

service=$1
echo "You want to monitor ${service}"

TIMESTAMP=`date +%Y_%m_%d`
if [ ! -d "monitor_logs" ] ; then
	mkdir -p monitor_logs
	chmod 777 monitor_logs
fi
	
MEM_USAGE_LOG_FILE=monitor_logs/${service}_mem_usage_${TIMESTAMP}.log
	
touch ${MEM_USAGE_LOG_FILE};
rc=$?

if [ $rc -ne 0 ]; then
	echo "G3 Monitor Commander: unable to create log file: ${MEM_USAGE_LOG_FILE}"
	exit 1
fi

chmod 777 ${MEM_USAGE_LOG_FILE}

### Log function ####
function log
{
  echo -e `date +"%Y-%m-%d %H:%M:%S"`' : '$1 >> ${MEM_USAGE_LOG_FILE}
}

##split_str=":"
MEM_UNIT=",KB"	
SLEEP_TIME=29

while : ; do

	service_pid=`cat /G3/logs/proc/${service}.pid`
	
	#echo "service pid is: ${service_pid}"

	if [ ! ${service_pid} ]; then	
		log "can't find shared serivce running"		
	else
		SS_VMRSS=`cat /proc/${service_pid}/status | grep -i VMRSS | awk '{print $2}'`
		SS_VMSWAP=`cat /proc/${service_pid}/status | grep -i VMSWAP | awk '{print $2}'`
		SS_VM_TOTL=`expr ${SS_VMRSS} "+" ${SS_VMSWAP}`
		log "${service} PID=${service_pid}, Physical Memory Allocated=${SS_VMRSS}${MEM_UNIT}, Swap Memory=${SS_VMSWAP}${MEM_UNIT}, Total Usage=${SS_VM_TOTL}${MEM_UNIT}"		
	fi

	sleep ${SLEEP_TIME}
	
done
