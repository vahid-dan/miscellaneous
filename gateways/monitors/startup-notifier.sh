#!/bin/bash

# Startup Notifier Script
# Executd from the Gateways
# Pushes the current system date and time to the default branch (main/master) of the Git repo as a notification of the gateway being awake
# Usage: Run after reboot.

__data_directory=/data
__applications_directory=$HOME/applications
__log_file=$__data_directory/$HOSTNAME-logs/startup-notifier.log
__git_directory=$__applications_directory/startup/FCRE-data
__git_repo=github.com:FLARE-forecast/FCRE-data.git

[ ! -d $__git_directory ] && git clone --depth=1 git@$__git_repo $__git_directory

cd $__git_directory
date > $HOSTNAME 2>&1 | tee -a $__log_file
git add $HOSTNAME 2>&1 | tee -a $__log_file
git commit -m "$(date)" 2>&1 | tee -a $__log_file
git pull --rebase 2>&1 | tee -a $__log_file
git push 2>&1 | tee -a $__log_file
