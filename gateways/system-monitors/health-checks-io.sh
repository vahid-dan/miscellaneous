#!/bin/bash

# HealthChecks.io Ping Script
# Executd from the Gateways
# Pings HealthChecks.io periodically as a notification of the gateway being awake
# Usage: Run periodically, every minute, for instance.

set -ex

config_file=/home/ubuntu/miscellaneous/gateways/config-files/config.yml

# Parse the config file using yq
health_checks_io_ping_url=$(yq e '.health_checks_io.ping_url' $config_file)

# Body of the script
curl -fsS --max-time 60 --retry 5 -o /dev/null $health_checks_io_ping_url
