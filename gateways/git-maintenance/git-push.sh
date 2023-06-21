#!/bin/bash

# Git Push Script
# Executd from the Gateways
# Adds the new changes to Git, commits them locally, and pushes them to the Git remote
# Usage: Run when new data or logs are available on the gateway, a few times per day, for instance.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_data_branch=$(yq e '.general.git_data_branch' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
git_push_log_file=$(yq e '.git_push.log_file' $config_file)
git_push_log_file_path=$general_data_dir/$general_git_logs_branch/$git_push_log_file

timestamp=$(date +"%D %T %Z")

# Body of the script

echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $git_push_log_file_path

echo -e "Data:\n" 2>&1 | tee -a $general_git_push_log_file_path
cd $general_data_dir/$general_git_data_branch
git add . 2>&1 | tee -a $git_push_log_file_path
git commit -m "$timestamp: Git Backup" 2>&1 | tee -a $git_push_log_file_path
#git pull --no-edit --force 2>&1 | tee -a $git_push_log_file_path
git push 2>&1 | tee -a $git_push_log_file_path

echo -e "\nLogs:\n" 2>&1 | tee -a $git_push_log_file_path
cd $general_data_dir/$general_git_logs_branch
git add . 2>&1 | tee -a $git_push_log_file_path
git commit -m "$timestamp: Logs" 2>&1 | tee -a $git_push_log_file_path
#git pull --no-edit --force 2>&1 | tee -a $git_push_log_file_path
git push 2>&1 | tee -a $git_push_log_file_path
git add . 2>&1 | tee -a $git_push_log_file_path
git commit -m "$timestamp: Logs" 2>&1 | tee -a $git_push_log_file_path
git push 2>&1 | tee -a $git_push_log_file_path

echo -e "\nCompleted at $(date +"%D %T %Z")\n" 2>&1 | tee -a $git_push_log_file_path
