#!/bin/bash

# Reverse SSH Module
# Executd from the Gateways
# Keeps an SSH tunnel open from the gateway to the server with a public IP address to make reverse SSH from the server to the gateway possible
# Usage: Run after reboot.
# Basic Test: ssh -R 60001:localhost:22 ubuntu@149.165.159.29

########## HEADER ##########

module_name=reverse_ssh

# Load utility functions and configurations for gateways
source /home/ubuntu/miscellaneous/gateways/base/utils.sh

# Check if the module is enabled
check_if_enabled "$module_name"

# Redirect all output of this module to log_to_file function
exec > >(while IFS= read -r line; do log_to_file "$module_name" "$line"; echo "$line"; done) 2>&1

echo "########## START ##########"

##########  BODY  ##########

AUTOSSH_DEBUG=1 autossh -o "ServerAliveInterval $reverse_ssh_ServerAliveInterval" -o "ServerAliveCountMax $reverse_ssh_ServerAliveCountMax" -M $reverse_ssh_base_port -R $reverse_ssh_local_port:$reverse_ssh_localhost:$reverse_ssh_remote_port -fNT $reverse_ssh_user@$reverse_ssh_server

########## FOOTER ##########

echo "##########  END  ##########"

# Close stdout and stderr
exec >&- 2>&-
# Wait for all background processes to complete
wait
