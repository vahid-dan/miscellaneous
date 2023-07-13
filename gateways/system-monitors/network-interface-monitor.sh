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
network_interface_monitor_interface=$(yq e '.network_interface_monitor.interface' $config_file)
network_interface_monitor_log_file_with_interface=$(echo "$network_interface_monitor_log_file" | sed "s/%(interface)s/$network_interface_monitor_interface/g")
network_interface_monitor_log_file_with_interface_path=$general_data_dir/$general_git_logs_branch/$network_interface_monitor_log_file_with_interface
network_interface_monitor_enabled=$(yq e '.network_interface_monitor.enabled' $config_file)

timestamp=$(date +"%D %T %Z %z")

# Body of the script

echo -e "\n############################ $general_gateway_name - $timestamp ############################\n"

# Check if the script is enabled
if [ "$network_interface_monitor_enabled" != "true" ]; then
  echo "The script is not enabled. Exiting ..."
  exit 0
fi

# Loop over each interface and log file configuration
interfaces=$(yq e '.network_interface_monitor.interfaces[]' $config_file)
for interface in $interfaces; do
  interface_name=$(echo "$interface" | yq e '.name' -)
  interface_log_file=$(echo "$interface" | yq e '.log_file' -)
  interface_log_file_path="$general_data_dir/$general_git_logs_branch/$interface_log_file"

  echo -e "\n############################ Interface: $interface_name ############################\n"

  while true; do
    # Check if the interface is up
    while ! ip link show $interface_name up &>/dev/null; do
      sleep 1  # Wait for 1 second before checking again
    done

    # Run tcpdump on the interface
    sudo tcpdump -i $interface_name -l -n | while read line; do
      echo "$(date "+%Y-%m-%d") $line" | tee -a $interface_log_file_path
    done
  done &
done

# Wait for all the background processes to complete before exiting the script 
wait
