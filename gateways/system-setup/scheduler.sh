#!/bin/bash

# Shutdown Scheduler Script
# Executd from the Gateways
# Shuts down the system according to the maintenance mode and power mode
# Usage: Run after reboot.

set -ex

config_file=/home/ubuntu/config.yml

# Parse the config file using yq

general_gateway_maintenance_mode=$(yq e '.general.gateway_maintenance_mode' $config_file)
general_gateway_power_mode=$(yq e '.general.gateway_power_mode' $config_file)
scheduler_shutdown_delay_after_reboot=$(yq e '.scheduler.shutdown_delay_after_reboot' $config_file)
scheduler_shutdown_time=$(yq e '.scheduler.shutdown_time' $config_file)

# Check the maintenance mode
if [ "$general_gateway_maintenance_mode" = "true" ]; then
    echo "The system is in maintenance mode. Shutdown is not allowed."
    exit 0
fi

# Check the power mode and schedule the shutdown accordingly
if [ "$general_gateway_power_mode" = "ac" ]; then
    echo "The system is in AC power mode. Scheduling shutdown at $scheduler_shutdown_time."
    # Schedule shutdown at the given time
    sudo shutdown -h "$scheduler_shutdown_time"
elif [ "$general_gateway_power_mode" = "battery" ]; then
    echo "The system is in battery power mode. Scheduling shutdown in $scheduler_shutdown_delay_after_reboot minutes after reboot."
    # Schedule shutdown after the given delay
    sudo shutdown -h +$scheduler_shutdown_delay_after_reboot
else
    echo "Unknown power mode: $general_gateway_power_mode"
    exit 1
fi
