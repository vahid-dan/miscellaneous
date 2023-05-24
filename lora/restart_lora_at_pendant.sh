#!/bin/sh

# This script is to be run in a fitlet2 gateway that is connected to a LoRa radio but not a cell link (e.g. at the FCR Weir)
# It configures the LoRa tnc0 interface, applies traffic control, and configures IP layer to route through the gateway it connects to
# It should run in crontab at boot time, and periodically (e.g. @hourly)
#
# this takes two arguments, 
# arg1 is the IP/netmask of the local tnc0 LoRa interface
# arg2 is which is the IP address of the gateway on the other side of the LoRa link
#
# The arguments $1 and $2 can be configured as follows:
#
# 1) If this fitlet has an EdgeVPN address:
# Here argument $1 should be a private address/netmask that is only visible between the two LoRa endpoints (i.e. this device's tnc0 address)
# Argument $2 should be also a private address/netmask that is only visible between the two LoRa endpoints (i.e. the other device's tnc0 address)
# The example below assumes the fitlet with LoRa only is 10.99.0.2 and the fitlet with both LoRa and cell is 10.99.0.1; the netmask is /24:
# restart_lora_at_pendant.sh 10.99.0.2/24 10.99.0.1
#
# 2) If this fitlet has an EdgeVPN address
# Here argument $1 should be the EdgeVPN IP/netmask assigned to the local tnc0 LoRa interface
# Argumet $2 should be the EdgeVPN IP/netmask assigned to the other device's appCIBR6 bridge
# The example below assumes the fitlet with LoRa only is 10.10.100.8 and the fitlet with both LoRa and cell is 10.10.100.7; the netmask is /24:
# restart_lora_at_pendant.sh 10.10.100.8/24 10.10.100.7

/usr/bin/killall tncattach
/usr/local/sbin/tncattach /dev/ttyUSB0 115200 -d -e -n -m 400 -i $1
/usr/sbin/tc qdisc add dev tnc0 root tbf rate 20kbit burst 32kbit latency 400ms

/usr/sbin/ip route delete default
/usr/sbin/ip route add default via $2
