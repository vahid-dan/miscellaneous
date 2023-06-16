#!/bin/bash

# Ping Monitor Script
# Executd from the Gateways
# Pings Google server to check the internet connectivity
# Usage: If required, run after reboot.

__data_directory=/data
__log_file_full=$__data_directory/$HOSTNAME-logs/ping-full.log
__log_file_stat=$__data_directory/$HOSTNAME-logs/ping-stat.log
timestamp=$(date +"%D %T %Z %z")

echo -e "\n############## $HOSTNAME - $timestamp ##############\n" 2>&1 | tee -a $__log_file_full
ping 8.8.8.8 -i 300 -c 284 | xargs -n1 -i bash -c 'echo `date +"%Y-%m-%d %H:%M:%S"`" {}"' 2>&1 | tee -a $__log_file_full

echo -e "\n############## $HOSTNAME - $timestamp ##############\n" 2>&1 | tee -a $__log_file_stat
tail -n 2 $__log_file_full 2>&1 | tee -a $__log_file_stat
