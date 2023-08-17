#!/bin/bash

# HealthChecks.io Ping Module
# Executd from the Gateways
# Pings HealthChecks.io periodically as a notification of the gateway being awake
# Usage: Run periodically, every minute, for instance.

module_name=health_checks_io

# Load configurations
source /home/ubuntu/miscellaneous/gateways/base/utils.sh

# Check if the module is enabled
check_if_enabled "$module_name"

# Body of the script
curl -fsS --max-time $health_checks_io_max_time --retry $health_checks_io_retry -o /dev/null $health_checks_io_ping_url
