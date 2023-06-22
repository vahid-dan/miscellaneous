#!/bin/bash

# Reverse SSH Script
# Executd from the Gateways
# Keeps an SSH tunnel open from the gateway to the server with a public IP address to make reverse SSH from the server to the gateway possible
# Usage: Run after reboot.
# Basic Test: ssh -R 60001:localhost:22 ubuntu@149.165.159.29

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config-files/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
reverse_ssh_log_file=$(yq e '.reverse_ssh.log_file' $config_file)
reverse_ssh_local_port=$(yq e '.reverse_ssh.local_port' $config_file)
reverse_ssh_base_port=$(yq e '.reverse_ssh.base_port' $config_file)
reverse_ssh_remote_port=$(yq e '.reverse_ssh.remote_port' $config_file)
reverse_ssh_localhost=$(yq e '.reverse_ssh.localhost' $config_file)
reverse_ssh_server=$(yq e '.reverse_ssh.server' $config_file)
reverse_ssh_user=$(yq e '.reverse_ssh.user' $config_file)
reverse_ssh_ServerAliveInterval=$(yq e '.reverse_ssh.ServerAliveInterval' $config_file)
reverse_ssh_ServerAliveCountMax=$(yq e '.reverse_ssh.ServerAliveCountMax' $config_file)
reverse_ssh_log_file_path=$general_data_dir/$general_git_logs_branch/$reverse_ssh_log_file

timestamp=$(date +"%D %T %Z %z")

# Body of the script
echo -e "\n############################ $general_gateway_name - $timestamp ############################\n" 2>&1 | tee -a $reverse_ssh_log_file_path
AUTOSSH_DEBUG=1 AUTOSSH_LOGFILE=$reverse_ssh_log_file_path autossh -o "ServerAliveInterval $reverse_ssh_ServerAliveInterval" -o "ServerAliveCountMax $reverse_ssh_ServerAliveCountMax" -M $reverse_ssh_base_port -R $reverse_ssh_local_port:$reverse_ssh_localhost:$reverse_ssh_remote_port -fNT $reverse_ssh_user@$reverse_ssh_server
