#!/bin/bash

G3_Service_Monitor=`pgrep -f Monitor_Impl.sh`

echo "PID:[${G3_Service_Monitor}]"

kill ${G3_Service_Monitor}
sleep 2
kill ${G3_Service_Monitor}


