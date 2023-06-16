#!/bin/bash

# Reverse SSH Script
# Executd from the Gateways
# Keeps an SSH tunnel open from the gateway to the server with a public IP address to make reverse SSH from the server to the gateway possible
# Usage: Run after reboot.

[ -d "/data/$HOSTNAME-logs" ] && __log_file=/data/$HOSTNAME-logs/autossh.log || __log_file=~/autossh.log
__timestamp=$(date +"%D %T %Z")

echo -e "\n############################ $HOSTNAME - $__timestamp ############################\n" 2>&1 | tee -a $__log_file

#ssh -R 60001:localhost:22 ubuntu@149.165.159.29

__local_port=60020
__base_port=61000
__remote_port=22
__localhost=localhost
__server=149.165.159.29
__user=ubuntu
AUTOSSH_DEBUG=1 AUTOSSH_LOGFILE=$__log_file autossh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 10" -M $__base_port -R $__local_port:$__localhost:$__remote_port -fNT $__user@$__server
