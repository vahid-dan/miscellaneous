#!/bin/bash

# Network Interface Monitor Script
# Executd from the Gateways
# Runs tcpdump to monitor a network interface
# Usage: If required, run after reboot.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config-files/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
network_interface_monitor_log_file=$(yq e '.network_interface_monitor.log_file' $config_file)
network_interface_monitor_log_file_path=$general_data_dir/$general_git_logs_branch/$network_interface_monitor_log_file
network_interface_monitor_interface=$(yq e '.network_interface_monitor.interface' $config_file)

timestamp=$(date +"%D %T %Z %z")

# Body of the script

echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $network_interface_monitor_log_file_path

while true; do
  # Check if the interface is up
  while ! ip link show $network_interface_monitor_interface up &>/dev/null; do
    sleep 1  # Wait for 1 second before checking again
  done

  # Start tcpdump with timestamp in output
  sudo nohup tcpdump -i $network_interface_monitor_interface -l -n | while read line; do
    echo "$(date "+%Y-%m-%d %H:%M:%S") $line" 2>&1 | tee -a $network_interface_monitor_log_file_path
  done

done
