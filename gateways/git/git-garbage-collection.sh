#!/bin/bash

# Git Garbage Collection Script
# Executd from the Gateways
# Runs Git Garbage Collector
# Usage: Run at least once every few weeks, recommended after running Git Push script for quicker runs.

__location=fcre-catwalk
__data_directory=/data
__logfile=$__data_directory/$HOSTNAME-logs/git-gc.log
__git_data_dir=$__data_directory/$__location-data
__git_log_dir=$__data_directory/$HOSTNAME-logs
__git_executable="/usr/bin/git"
__timestamp=$(date +"%D %T %Z")

echo -e "\n############################ $HOSTNAME - $__timestamp ############################\n" 2>&1 | tee -a $__log_file

echo -e "Disk Usage Before Git Garbage Collection:" 2>&1 | tee -a $__logfile
df -h | grep $__data_directory 2>&1 | tee -a $__logfile

cd $__git_data_dir
echo -e "Working on: $(pwd)" 2>&1 | tee -a $__logfile
$__git_executable gc --prune 2>&1 | tee -a $__logfile

cd $__git_log_dir
echo -e "Working on: $(pwd)" 2>&1 | tee -a $__logfile
$__git_executable gc --prune 2>&1 | tee -a $__logfile

echo -e "Disk Usage After Git Garbage Collection:" 2>&1 | tee -a $__logfile
df -h | grep $__data_directory 2>&1 | tee -a $__logfile
