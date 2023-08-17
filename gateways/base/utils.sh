#!/bin/bash

set -ex

# Load config
source /home/ubuntu/miscellaneous/gateways/config-files/config.sh

# Check if module is enabled
check_if_enabled() {
  module_enabled_var="${1}_enabled"

  if [ "${!module_enabled_var}" != "true" ]; then
    echo "Script $1 is not enabled. Exiting..." 
    exit 0
  fi
}

# Log message to file
log_to_file() {
  local module=$1
  local message=$2
  local log_file="${module}_log_file"

  echo -e "$(date +"%D %T %Z %z") | $message" 2>&1 | tee -a "$general_data_dir/$general_git_logs_branch/${!log_file}" 
}

# Parse config value
get_config_value() {
  local module=$1
  local key=$2

  yq e ".$module.$key" $config_file
}
