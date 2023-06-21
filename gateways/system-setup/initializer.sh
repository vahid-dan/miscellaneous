#!/bin/bash

# Gateway Initialization Script
# Executd from the Gateways
# Initializes the gateway environment
# Usage: Run once for the first time to initialize the gateway based on the configuration settings

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config.yml

# Parse the config file using yq
general_gateway_name=$(yq e '.general.gateway_name' $config_file)
general_data_dir=$(yq e '.general.data_dir' $config_file)
general_apps_dir=$(yq e '.general.apps_dir' $config_file)
general_git_repo=$(yq e '.general.git_repo' $config_file)
general_git_data_branch=$(yq e '.general.git_data_branch' $config_file)
general_git_logs_branch=$(yq e '.general.git_logs_branch' $config_file)
general_datalogger_data_dir=$(yq e '.general.datalogger_data_dir' $config_file)
startup_notifier_local_repo_dir=$(yq e '.startup_notifier.local_repo_dir' $config_file)
startup_notifier_git_branch=$(yq e '.startup_notifier.git_branch' $config_file)
startup_notifier_git_repo=$(yq e '.startup_notifier.git_repo' $config_file)
general_data_dir_path=$general_data_dir/$general_git_data_branch
general_logs_dir_path=$general_data_dir/$general_git_logs_branch

# Body of the script

# Change hostname
sudo hostname $general_gateway_name

# Setup datalogger directory symbolic link
if [ ! -L $general_data_dir/$general_datalogger_data_dir ]; then
  echo "Creating datalogger directory symbolic link"
  ln -s $general_data_dir/$general_git_data_branch $general_data_dir/$general_datalogger_data_dir
else
  echo "Datalogger directory already exists."
fi

# Clone the latest commit from the data branch if the directory does not exist
if [ ! -d "$general_data_dir_path" ]; then
  echo "Cloning data branch"
  git clone --depth 1 --branch $general_git_data_branch $general_git_repo $general_data_dir_path
else
  echo "Data directory already exists. Pulling the latest version ..."
  cd $general_data_dir_path
  git pull
fi

# Clone the latest commit from the logs branch if the directory does not exist
if [ ! -d "$general_logs_dir_path" ]; then
  echo "Cloning logs branch"
  git clone --depth 1 --branch $general_git_logs_branch $general_git_repo $general_logs_dir_path
else
  echo "Logs directory already exists. Pulling the latest version ..."
  cd $general_logs_dir_path
  git pull
fi

# Clone the latest commit from the startup branch if the directory does not exist
if [ ! -d "$general_apps_dir/$startup_notifier_local_repo_dir" ]; then
  echo "Cloning startup notifier branch"
  git clone --depth 1 --branch $startup_notifier_git_branch $startup_notifier_git_repo $general_apps_dir/$startup_notifier_local_repo_dir
else
  echo "Startup notifier directory already exists. Pulling the latest version ..."
  cd $general_apps_dir/$startup_notifier_local_repo_dir
  git pull
fi
