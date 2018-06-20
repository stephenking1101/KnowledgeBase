#!/bin/bash
#
# Execute shell script with below format:
#
#    /SCRIPT_HOME/Load_Config.sh <ENVIRONMENT>
#
# For example:
#
#    /SCRIPT_HOME/Load_Config.sh dev2
#
###################################################################################################

ENV=$1

SCRIPT_DIR=$(dirname `readlink -f $0`)
cd ${SCRIPT_DIR}

CONFIG_FILE=./conf/configuration.${ENV}.conf
#echo "configuration file is: ${CONFIG_FILE}"

Deploy_Singal_File=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Deploy_Singal_File' | cut -d "=" -f2`
Deploy_Singal_File=`eval echo ${Deploy_Singal_File}`

Commander_Singal_File=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Commander_Singal_File' | cut -d "=" -f2`
Commander_Singal_File=`eval echo ${Commander_Singal_File}`

Target_Release_Items_Path=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Target_Release_Items_Path' | cut -d "=" -f2`
Target_Release_Items_Path=`eval echo ${Target_Release_Items_Path}`

Log_Dir=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Log_Dir' | cut -d "=" -f2`
Log_Dir=`eval echo ${Log_Dir}`

Working_Area=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Working_Area' | cut -d "=" -f2`
Working_Area=`eval echo ${Working_Area}`

Deploy_App_Backup_Dir=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Deploy_App_Backup_Dir' | cut -d "=" -f2`
Deploy_App_Backup_Dir=`eval echo ${Deploy_App_Backup_Dir}`


Base_Dir=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Base_Dir' | cut -d "=" -f2`
Base_Dir=`eval echo ${Base_Dir}`

#Oracle_Home_Dir=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Oracle_Home_Dir' | cut -d "=" -f2`
#Oracle_Home_Dir=`eval echo ${Oracle_Home_Dir}`

#Key_File=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Key_File' | cut -d "=" -f2`
#Key_File=`eval echo ${Key_File}`

#DB_Password_File=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'DB_Password_File' | cut -d "=" -f2`
#DB_Password_File=`eval echo ${DB_Password_File}`

#DB_User_Name=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'DB_User_Name' | cut -d "=" -f2`
#DB_User_Name=`eval echo ${DB_User_Name}`

#DB_Host=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'DB_Host' | cut -d "=" -f2`
#DB_Host=`eval echo ${DB_Host}`

#DB_Port=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'DB_Port' | cut -d "=" -f2`
#DB_Port=`eval echo ${DB_Port}`

#DB_Service=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'DB_Service' | cut -d "=" -f2`
#DB_Service=`eval echo ${DB_Service}`

Commander_Dir=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Commander_Dir' | cut -d "=" -f2`
Commander_Dir=`eval echo ${Commander_Dir}`

Daemon_Log_Retention_Period=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Daemon_Log_Retention_Period' | cut -d "=" -f2`
Daemon_Log_Retention_Period=`eval echo ${Daemon_Log_Retention_Period}`

Daemon_Log_Time_Format=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Daemon_Log_Time_Format' | cut -d "=" -f2`
Daemon_Log_Time_Format=`eval echo ${Daemon_Log_Time_Format}`

Host_Name=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Host_Name' | cut -d "=" -f2`
Host_Name=`eval echo ${Host_Name}`

Server_Name=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Server_Name' | cut -d "=" -f2`
Server_Name=`eval echo ${Server_Name}`

Work_User=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Work_User' | cut -d "=" -f2`
Work_User=`eval echo ${Work_User}`

WAS_Server_CCM=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'WAS_Server_CCM' | cut -d "=" -f2`
WAS_Server_CCM=`eval echo ${WAS_Server_CCM}`

WAS_Server_G3=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'WAS_Server_G3' | cut -d "=" -f2`
WAS_Server_G3=`eval echo ${WAS_Server_G3}`

WAS_Server_JTS=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'WAS_Server_JTS' | cut -d "=" -f2`
WAS_Server_JTS=`eval echo ${WAS_Server_JTS}`

WAS_Cluster_CCM=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'WAS_Cluster_CCM' | cut -d "=" -f2`
WAS_Cluster_CCM=`eval echo ${WAS_Cluster_CCM}`

WAS_Cluster_G3=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'WAS_Cluster_G3' | cut -d "=" -f2`
WAS_Cluster_G3=`eval echo ${WAS_Cluster_G3}`

WAS_Cluster_JTS=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'WAS_Cluster_JTS' | cut -d "=" -f2`
WAS_Cluster_JTS=`eval echo ${WAS_Cluster_JTS}`

declare -A wasServers
declare -A wasClusters

wasServers["ccm"]=${WAS_Server_CCM}
wasServers["g3"]=${WAS_Server_G3}
wasServers["jts"]=${WAS_Server_JTS}

wasClusters["ccm"]=${WAS_Cluster_CCM}
wasClusters["g3"]=${WAS_Cluster_G3}
wasClusters["jts"]=${WAS_Cluster_JTS}

Target_RTC_Plugin_Folder=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Target_RTC_Plugin_Folder' | cut -d "=" -f2`
Target_RTC_Plugin_Folder=`eval echo ${Target_RTC_Plugin_Folder}`

Request_Reset_Script=`cat ${CONFIG_FILE} | egrep -v '^#' | grep 'Request_Reset_Script' | cut -d "=" -f2`
Request_Reset_Script=`eval echo ${Request_Reset_Script}`

#DB_Password=`./password/decryptpwd.sh ${Key_File} ${DB_Password_File}`

#export ORACLE_HOME=${Oracle_Home_Dir}

#echo "password is: ${DB_Password}"
#echo "source path=${Singal_File_Source_Path}"
#echo "target path=${Singal_File_Target_Path}"
#echo "release items path=${Target_Release_Items_Path}"
#echo "working area=${Working_Area}"
#echo "base dir=${Base_Dir}"
#echo "target environment=${ENV}"
#echo "release work item=${RWI}"
#echo "oracle home=${Oracle_Home_Dir}"
