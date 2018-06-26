#!/usr/bin/python
import os
import re
import subprocess
import time

#
# run command and check its status and output
#
def run_cmd(cmd):
    print("Start running command '%s'" % cmd)
    
    popen = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    
    status = popen.returncode
    
    print("Finish running command. Return status: %s" % status)
    
    current_time = time.strftime('%Y-%m-%d-%X', time.localtime())
    
    output = current_time
    
    return status, output



