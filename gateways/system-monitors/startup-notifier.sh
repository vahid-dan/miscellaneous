#!/bin/bash

# Startup Notifier Script
# Executd from the Gateways
# Pushes the current system date and time to the default branch (main/master) of the Git repo as a notification of the gateway being awake
# Usage: Run after reboot.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config-files/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_apps_dir=$(yq e '.general.apps_dir' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
startup_notifier_local_repo_dir=$(yq e '.startup_notifier.local_repo_dir' $config_file)
startup_notifier_log_file=$(yq e '.startup_notifier.log_file' $config_file)
startup_notifier_log_file_path=$general_data_dir/$general_git_logs_branch/$startup_notifier_log_file

# Body of the script
cd $general_apps_dir/$startup_notifier_local_repo_dir/$general_gateway_name
date > $general_gateway_name 2>&1 | tee -a $startup_notifier_log_file_path
git add $general_gateway_name 2>&1 | tee -a $startup_notifier_log_file_path
git commit -m "$(date +"%D %T %Z %z")
)" 2>&1 | tee -a $startup_notifier_log_file_path
git pull --rebase 2>&1 | tee -a $startup_notifier_log_file_path
git push 2>&1 | tee -a $startup_notifier_log_file_path
