#!/bin/bash

# Status Monitor Script
# Executd from the Gateways
# Logs the current status of the system by checking on various services
# Usage: Run at least once after reboot, a few times per day, for instance.

__data_directory=/data
__log_file=$__data_directory/$HOSTNAME-logs/status-monitor.log
__timestamp=$(date +"%D %T %Z")

echo -e "\n############################ $HOSTNAME - $__timestamp ############################\n" 2>&1 | tee -a $__log_file
uptime 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
/usr/bin/last reboot | head -n 5 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
systemctl status cron | grep ".service - \|Active:"
systemctl status watchdog | grep ".service - \|Active:"
echo -e "\n" 2>&1 | tee -a $__log_file
/usr/bin/lsusb | grep Novatel 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
dmesg | grep enx 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
dmesg | tail 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
df -h | grep Filesystem 2>&1 | tee -a $__log_file
df -h | grep /dev/mmcblk 2>&1 | tee -a $__log_file
df -h | grep /dev/sd 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
nmcli d wifi list 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
/sbin/ip a | grep 'enx' | awk '{print $2}' 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
/sbin/ip a | grep 'enp1s0' | awk '{print $2}' 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
/sbin/ip a | grep 'enp2s0' | awk '{print $2}' 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
ping -c 3 github.com 2>&1 | tee -a $__log_file
echo -e "\n" 2>&1 | tee -a $__log_file
ping -c 3 8.8.8.8 2>&1 | tee -a $__log_file
