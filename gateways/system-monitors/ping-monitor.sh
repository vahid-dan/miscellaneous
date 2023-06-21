#!/bin/bash

# Ping Monitor Script
# Executd from the Gateways
# Pings Google server to check the internet connectivity
# Usage: If required, run after reboot.
# Be careful about the size of the ping_monitor_log_file_full as it can get quite large.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
ping_monitor_log_file_full=$(yq e '.ping_monitor.log_file_full' $config_file)
ping_monitor_log_file_stat=$(yq e '.ping_monitor.log_file_stat' $config_file)
ping_monitor_log_file_full_path=$general_data_dir/$general_git_logs_branch/$ping_monitor_log_file_full
ping_monitor_log_file_stat_path=$general_data_dir/$general_git_logs_branch/$ping_monitor_log_file_stat

timestamp=$(date +"%D %T %Z %z")

# Body of the script

echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $ping_monitor_log_file_full_path
ping 8.8.8.8 -i 1 -c 3 | xargs -n1 -i bash -c 'echo `date +"%Y-%m-%d %H:%M:%S"`" {}"' 2>&1 | tee -a $ping_monitor_log_file_full_path

echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $ping_monitor_log_file_stat_path
tail -n 2 $ping_monitor_log_file_full_path 2>&1 | tee -a $ping_monitor_log_file_stat_path
