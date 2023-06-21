#!/bin/bash

# Git Garbage Collector Script
# Executd from the Gateways
# Runs Git Garbage Collector
# Usage: Run at least once every few weeks, recommended after running Git Push script for quicker runs.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_data_branch=$(yq e '.general.git_data_branch' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
git_garbage_collector_log_file=$(yq e '.git_garbage_collector.log_file' $config_file)
git_garbage_collector_log_file_path=$general_data_dir/$general_git_logs_branch/$git_garbage_collector_log_file

timestamp=$(date +"%D %T %Z %z")

# Body of the script

echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $git_garbage_collector_log_file_path

echo -e "Disk Usage Before Git Garbage Collector:" 2>&1 | tee -a $git_garbage_collector_log_file_path
df -h | grep $general_data_dir 2>&1 | tee -a $git_garbage_collector_log_file_path

cd $general_data_dir/$general_git_data_branch
echo -e "Working on: $(pwd)" 2>&1 | tee -a $git_garbage_collector_log_file_path
git gc --prune 2>&1 | tee -a $git_garbage_collector_log_file_path

cd $general_data_dir/$general_git_logs_branch
echo -e "Working on: $(pwd)" 2>&1 | tee -a $git_garbage_collector_log_file_path
git gc --prune 2>&1 | tee -a $git_garbage_collector_log_file_path

echo -e "Disk Usage After Git Garbage Collector:" 2>&1 | tee -a $git_garbage_collector_log_file_path
df -h | grep $general_data_dir 2>&1 | tee -a $git_garbage_collector_log_file_path
