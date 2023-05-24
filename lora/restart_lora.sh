#!/bin/sh

# this script is to be run in a gateway that is:
# 1) connected to a LoRa radio but not a cell link (e.g. at the FCR Weir), -and-
# 2) using an EdgeVPN address (argument $1 for this script)

# This script restarts Rnode LoRa on a node that is *not* acting as an Evio switch
# It kills and restarts tncattach and adds a tc traffic control entry
# it takes one argument with IP address and netmask, e.g. 10.10.100.10/24

/usr/bin/killall tncattach
/usr/local/sbin/tncattach /dev/ttyUSB0 115200 -d -e -n -m 400 -i $1
/usr/sbin/tc qdisc add dev tnc0 root tbf rate 20kbit burst 32kbit latency 400ms
