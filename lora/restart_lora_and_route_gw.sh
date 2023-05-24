#!/bin/sh

# this script is to be run in a gateway that is:
# 1) connected to a LoRa radio but not a cell link (e.g. at the FCR Weir), -and-
# 2) not using an EdgeVPN address
# Here argument $1 should not be an EdgeVPN address, but rather a private address between LoRa endpoints
# The example below assumes the fitlet with LoRa only is 10.99.0.2 and the fitlet with both LoRa and cell is 10.99.0.1 

# this takes two arguments, 
# arg1 is the IP/netmask of the local tnc0 LoRa interface
# arg2 is which is the evio IP address of the evio_switch gateway
# e.g. 10.99.0.2/24 10.99.0.1

/usr/bin/killall tncattach
/usr/local/sbin/tncattach /dev/ttyUSB0 115200 -d -e -n -m 400 -i $1
/usr/sbin/tc qdisc add dev tnc0 root tbf rate 20kbit burst 32kbit latency 400ms

/usr/sbin/ip route delete default
/usr/sbin/ip route add default via $2
