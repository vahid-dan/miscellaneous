#!/bin/bash

# LED Off Script
# Executd from the Gateways
# Turns off both LED1 and LED2 on the gateways.
# Usage: Run after reboot.

set -ex

# Note: GPIO pins have been updated in the newer versions of Fitlet2:
# $ ls /sys/class/gpio

# Turn off the LED1 on the gateways
echo 435 > /sys/class/gpio/export
echo 0 > /sys/class/gpio/gpio435/value

# Turn off the LED2 on the gateways
echo 437 > /sys/class/gpio/export
echo 0 > /sys/class/gpio/gpio437/value