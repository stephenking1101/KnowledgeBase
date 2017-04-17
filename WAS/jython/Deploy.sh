#!/bin/bash

IDEPLOY_ROOT=$1
shift
artDropLocTarget=$1
shift
targetName=$1
shift
wasOptions=$1
shift
connectOptions=$1
shift
envOptions=$1
shift
appInstallOptions=$1
shift
customOptions=$1
shift
appAttribOptions=$*


if [[ -f ${IDEPLOY_ROOT}/scripts/wrappers.Functions ]]
then
   . ${IDEPLOY_ROOT}/scripts/wrappers.Functions
else
   echo
   echo "[CRITICAL] - ***** FATAL ERROR ***** : Function File (wrappers.Functions) was not found. [$HOSTNAME] - [FAIL]"
   exit 1
fi

version="4.1"

echo
echo "=========================================================================="
echo "[INFO] Running iDeploy-lite package version => $version"
echo "=========================================================================="
echo

logDirName="/tmp/iDeploy-lite/logs"
soapRequestTimeOut=''

if [[ ! -d ${logDirName} ]]
then
   mkdir -p ${logDirName}
fi

for envOpt in $envOptions
do
   envOpt=`echo $envOpt | sed 's/--//'`
   eval $envOpt
done

for wasOpt in $wasOptions
do
   wasOpt=`echo $wasOpt | sed 's/--//'`
   eval $wasOpt
done

if [[ -z ${envkey} ]]
then
    echo "[CRITICAL] - ***** FATAL ERROR ***** : Environment Key value not specified in the envOptions - [FAIL]"
    exit 2
fi

if [[ -n "$soapRequestTimeOut" ]]
then

fi

logFileName=${logDirName}/installation_${envkey}.log

if [[ $topology == 'cluster' ]]
then
    wsAdminBinDir=${dmgrProfilePath}/bin
elif [[ $topology == 'standalone' ]]
then
    wsAdminBinDir=${stdProfilePath}/bin
    if [[ $nodeName  == '' ]]
    then
        echo "[CRITICAL] - ***** FATAL ERROR ***** : nodeName value not specified in the application.properties file - [FAIL]"
        exit 5
    fi
elif [[ $topology == '' ]]
then
    echo "[CRITICAL] - ***** FATAL ERROR ***** : topology value not specified in the application.properties file - [FAIL]"
    exit 6
fi

if [[ $targetName == '' ]]
then
    echo "[CRITICAL] - ***** FATAL ERROR ***** : targetName value not specified in the application.properties file - [FAIL]"
    exit 7
fi

earAppPathTarget=${artDropLocTarget}/earApp
warAppPathTarget=${artDropLocTarget}/warApp

earAppCount=`ls -1 ${artDropLocTarget}/*.ear 2>/dev/null | wc -l`
warAppCount=`ls -1 ${artDropLocTarget}/*.war 2>/dev/null | wc -l`
 
if [[ $earAppCount -eq 1 ]]
then
     mkdir ${earAppPathTarget} 2>/dev/null
     cp ${artDropLocTarget}/*.ear ${earAppPathTarget}
elif [[ $earAppCount -gt 1 ]]
then
    echo "[CRITICAL] - ***** FATAL ERROR ***** : More than one ear application found in the same drop location - [FAIL]"
    exit 8
fi
 
if [[ $warAppCount -eq 1 ]]
then
     mkdir ${warAppPathTarget} 2>/dev/null
     cp ${artDropLocTarget}/*.war ${warAppPathTarget}
elif [[ $warAppCount -gt 1 ]]
then
    echo "[CRITICAL] - ***** FATAL ERROR ***** : More than one war application found in the same drop location - [FAIL]"
    exit 9
fi 
       
if [[ -d ${earAppPathTarget} ]]
then
     appLoc=`ls -1 ${earAppPathTarget}/*.ear 2>/dev/null`
     appFileName=`basename $appLoc 2>/dev/null`
     appName=${appFileName:0:${#appFileName}-4}
     artType="ear"
     appPathTarget=${earAppPathTarget}
elif [[ -d ${warAppPathTarget} ]]
then
     appLoc=`ls -1 ${warAppPathTarget}/*.war 2>/dev/null`
     appFileName=`basename $appLoc 2>/dev/null`
     appName=${appFileName:0:${#appFileName}-4}
     artType="war"
     appPathTarget=${warAppPathTarget}
else
    echo "[CRITICAL] - ***** FATAL ERROR ***** : No valid artefacts directory found - [FAIL]"
    exit 10
fi 

export IDEPLOY_ROOT=$IDEPLOY_ROOT; $wsAdminBinDir/wsadmin.sh -lang jython $connectOptions $soapRequestTimeOutOption -javaoption -Dpython.home=${wasHome}/optionalLibraries/jython -f ${IDEPLOY_ROOT}/g3-was.jython ${appPathTarget} ${appName} ${artType} ${targetName} "${envOptions}" "${appInstallOptions}" "${customOptions}" $appAttribOptions > ${logFileName} 

RC=$?
cat ${logFileName}

if [[ $RC -ne 0 ]]
then
   echo "[CRITICAL] - ***** FATAL ERROR ***** : Error encountered while invoking application installation script on [`hostname`] - [FAIL]"
   exit 11
else
   grep "CRITICAL" ${logFileName} >/dev/null
   if [[ $? -eq 0 ]]
   then
      echo "[CRITICAL] - ***** FATAL ERROR ***** : Error encountered while invoking application installation script on [`hostname`] - [FAIL]"
      exit 12
   fi
fi

exit 0
