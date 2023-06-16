#!/bin/bash

# Git Push Script
# Executd from the Gateways
# Adds the new changes to Git, commits them locally, and pushes them to the Git remote
# Usage: Run when new data or logs are available on the gateway, a few times per day, for instance.

__location=fcre-catwalk
__data_directory=/data
#__datalogger_dir=/data/datalogger-data
__log_file=$__data_directory/$HOSTNAME-logs/git-push.log
__git_data_dir=$__data_directory/$__location-data
__git_log_dir=$__data_directory/$HOSTNAME-logs
__git_executable="/usr/bin/git"
__timestamp=$(date +"%D %T %Z")

echo -e "\n############################ $HOSTNAME - $__timestamp ############################\n" 2>&1 | tee -a $__log_file

echo -e "Data:\n" 2>&1 | tee -a $__log_file

#cp -rf $__datalogger_dir/* $__git_data_dir
cd $__git_data_dir
$__git_executable add . 2>&1 | tee -a $__log_file
$__git_executable commit -m "$__timestamp: Git Backup" 2>&1 | tee -a $__log_file
#$__git_executable pull --no-edit --force 2>&1 | tee -a $__log_file
$__git_executable push 2>&1 | tee -a $__log_file

echo -e "\nLogs:\n" 2>&1 | tee -a $__log_file

cd $__git_log_dir
$__git_executable add . 2>&1 | tee -a $__log_file
$__git_executable commit -m "$__timestamp: Logs" 2>&1 | tee -a $__log_file
#$__git_executable pull --no-edit --force 2>&1 | tee -a $__log_file
$__git_executable push 2>&1 | tee -a $__log_file
$__git_executable add . 2>&1 | tee -a $__log_file
$__git_executable commit -m "$__timestamp: Logs" 2>&1 | tee -a $__log_file
$__git_executable push 2>&1 | tee -a $__log_file

echo -e "\nCompleted at $(date +"%D %T %Z")\n" 2>&1 | tee -a $__log_file
