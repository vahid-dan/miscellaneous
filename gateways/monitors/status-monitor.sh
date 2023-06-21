#!/bin/bash

# Status Monitor Script
# Executd from the Gateways
# Logs the current status of the system by checking on various services
# Usage: Run at least once after reboot, a few times per day, for instance.

set -ex

config_file=/home/ubuntu/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
status_monitor_log_file=$(yq e '.status_monitor.log_file' $config_file)
status_monitor_log_file_path=$general_data_dir/$general_git_logs_branch/$status_monitor_log_file

timestamp=$(date +"%D %T %Z")

# Body of the script
echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $status_monitor_log_file_path
uptime 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
/usr/bin/last reboot | head -n 5 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
#systemctl status cron | grep ".service - \|Active:"
#systemctl status watchdog | grep ".service - \|Active:"
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
/usr/bin/lsusb | grep Novatel 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
dmesg | grep enx 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
dmesg | tail 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
df -h | grep Filesystem 2>&1 | tee -a $status_monitor_log_file_path
df -h | grep /dev/mmcblk 2>&1 | tee -a $status_monitor_log_file_path
df -h | grep /dev/sd 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
#nmcli d wifi list 2>&1 | tee -a $status_monitor_log_file_path
#echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
/sbin/ip a | grep 'enx' | awk '{print $2}' 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
/sbin/ip a | grep 'enp1s0' | awk '{print $2}' 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
/sbin/ip a | grep 'enp2s0' | awk '{print $2}' 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
ping -c 3 github.com 2>&1 | tee -a $status_monitor_log_file_path
echo -e "\n" 2>&1 | tee -a $status_monitor_log_file_path
ping -c 3 8.8.8.8 2>&1 | tee -a $status_monitor_log_file_path
