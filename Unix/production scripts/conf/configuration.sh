#!/bin/bash
##########################################################
# Description: This script will help to init any
#              environment specific configuration
# Usage:       <dev|uat|prod|dr>
##########################################################

environmentAlias=$1

# validate the command args
if [ "$environmentAlias" != "dev" ] && [ "$environmentAlias" != "uat" ] && [ "$environmentAlias" != "prod" ] && [ "$environmentAlias" != "dr" ]; then
  echo "Error:   Please supply a valid environment"
  exit
fi

echo "Loading configuration for ${environmentAlias}..."

declare -A wasServers
declare -A wasClusters

# set the environment specific variables
if [ "$environmentAlias" == "dev" ]; then

  hostname="hkgv3ls0930o.h"
  server="hkgv3ls0930o"
  user="g3dev"
  rtcRootDirectory="/G3/G3RTC_DEV/"
  rtcRootUrl="https://g3:9105/jazz"

  wasServers["ccm"]="DASJAZ0101UK"
  wasServers["g3"]="DASG3W0101UK"
  wasServers["jts"]="DASJTS0101UK"

  wasClusters["ccm"]="DJAZ01HK"
  wasClusters["g3"]="DG3W01HK"
  wasClusters["jts"]="DJTS01HK"

elif [ "$environmentAlias" == "uat" ]; then

  hostname="gbl07791.sys"
  server="gbl07791"
  user="g3uat"
  rtcRootDirectory="/G3/G3RTC_UAT/"
  rtcRootUrl="https://g3:9104/jazz"

  wasServers["ccm"]="UASCCM0101UK"
  wasServers["g3"]="UASG3W0101UK"
  wasServers["jts"]="UASJTS0101UK"

  wasClusters["ccm"]="UCCM01UK"
  wasClusters["g3"]="UG3W01UK"
  wasClusters["jts"]="UJTS01UK"

elif [ "$environmentAlias" == "prod" ]; then

  hostname="gbl07847.s"
  server="gbl07847"
  user="g3sys"
  rtcRootDirectory="/G3/G3RTC/"
  rtcRootUrl="https://g3:9097/jazz"

  wasServers["ccm"]="CASCCM0107UK"
  wasServers["g3"]="CASG3W0101UK"
  wasServers["jts"]="CASJTS0107UK"

  wasClusters["ccm"]="CCCM0107UK"
  wasClusters["g3"]="CG3W0101UK"
  wasClusters["jts"]="CJTS0107UK"

elif [ "$environmentAlias" == "dr" ]; then

  hostname="gbl07816.sy"
  server="gbl07816"
  user="g3sys"
  rtcRootDirectory="/G3/G3RTC/"
  rtcRootUrl="https://g3:9097/jazz"

  wasServers["ccm"]="LASCCM0107UK"
  wasServers["g3"]="LASG3W0101UK"
  wasServers["jts"]="LASJTS0107UK"

  wasClusters["ccm"]="LCCM0107UK"
  wasClusters["g3"]="LG3W0101UK"
  wasClusters["jts"]="LJTS0107UK"

fi
