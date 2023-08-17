#!/bin/bash

# Network Interface Monitor Module
# Executed from the Gateways
# Runs tcpdump to monitor a network interface
# Usage: If required, run after reboot.

set -ex

module_name=network_interface_monitor

# Load configurations
source gateways/base/utils.sh

# Check if the module is enabled
check_if_enabled "$module_name"

# Loop over each interface and log file configuration
interfaces=$(yq e '.network_interface_monitor.interfaces | keys | .[]' $config_file)
for interface in $interfaces; do

  # Get interface name
  interface_name=$(yq e ".network_interface_monitor.interfaces[$interface].name" $config_file) 
  
  # Get log file path
  interface_log_file=$(yq e ".network_interface_monitor.interfaces[$interface].log_file" $config_file)

  # Construct full log file path 
  log_file_path="$data_dir/$git_logs_branch/$interface_log_file"

  # Continuously monitor interface
  while true; do
    
    # Wait for interface to be up
    while ! ip link show $interface_name up &>/dev/null; do
      sleep 1
    done

    # Start tcpdump process
    sudo tcpdump -i $interface_name -G $network_interface_monitor_log_rotation_interval -w "$log_file_path"_%Y-%m-%d_%H:%M:%S.pcap &
    pid=$!

    # Monitor tcpdump process
    while kill -0 $pid && ip link show $interface_name up &>/dev/null; do
      sleep 1
    done

    # Handle stopping tcpdump
    if kill -0 $pid; then
      sudo kill $pid
      wait $pid
    fi

    # Restart when interface back up
    if ip link show $interface_name up &>/dev/null; then
      continue
    fi

    # Wait for interface to be up again
    while ! ip link show $interface_name up &>/dev/null; do
      sleep 1
    done

  done &

done

# Wait for background processes
wait
