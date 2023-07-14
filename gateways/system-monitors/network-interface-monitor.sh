#!/bin/bash

# Network Interface Monitor Script
# Executed from the Gateways
# Runs tcpdump to monitor a network interface
# Usage: If required, run after reboot.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config-files/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
network_interface_monitor_enabled=$(yq e '.network_interface_monitor.enabled' $config_file)
network_interface_monitor_log_rotation_interval=$(yq e '.network_interface_monitor.log_rotation_interval' $config_file)

# Body of the script

# Check if the script is enabled
if [ "$network_interface_monitor_enabled" != "true" ]; then
  echo "The script is not enabled. Exiting ..."
  exit 0
fi

# Loop over each interface and log file configuration
interfaces=$(yq e '.network_interface_monitor.interfaces | keys | .[]' $config_file)
for interface in $interfaces; do
  interface_name=$(yq e ".network_interface_monitor.interfaces[\"$interface\"].name" $config_file)
  interface_log_file=$(yq e ".network_interface_monitor.interfaces[\"$interface\"].log_file" $config_file)
  interface_log_file_path="$general_data_dir/$general_git_logs_branch/$interface_log_file"

  while true; do
    # Check if the interface is up
    while ! ip link show $interface_name up &>/dev/null; do
      sleep 1  # Wait for 1 second before checking again
    done

    # Run tcpdump on the interface and write output to the file
    sudo tcpdump -i $interface_name -G $network_interface_monitor_log_rotation_interval -w "$interface_log_file_path"_%Y-%m-%d_%H:%M:%S.pcap &
    pid=$!

    # Wait for tcpdump to stop, or for the interface to go down
    while kill -0 $pid && ip link show $interface_name up &>/dev/null; do
      sleep 1  # Wait for 1 second before checking again
    done

    # If tcpdump is still running, stop it
    if kill -0 $pid; then
      sudo kill $pid
      wait $pid
    fi

    # If the interface is still up, start tcpdump again
    if ip link show $interface_name up &>/dev/null; then
      continue
    fi

    # Wait for the interface to come back up before starting tcpdump again
    while ! ip link show $interface_name up &>/dev/null; do
      sleep 1  # Wait for 1 second before checking again
    done
  done &
done

# Wait for all the background processes to complete before exiting the script 
wait
