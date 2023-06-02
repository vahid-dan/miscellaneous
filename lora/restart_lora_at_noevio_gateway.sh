#!/bin/sh

# This script is to be run in a fitlet2 gateway that is connected to a LoRa radio but not a cell link (e.g. at the FCR Weir)
# Note **run this script only if the fitlet is not running as an EdgeVPN (evio) switch to the other node**
# If using evio, run restart_lora_at_evio_switch.sh
# It configures the LoRa tnc0 interface, applies traffic control, and configures IP layer as NAT
# It should run in crontab at boot time, and periodically (e.g. @hourly)

# this take the tnc0 network address of this gateway and netmask as the only argument
# e.g. restart_lora_at_noevio_gateway.sh 10.99.0.1/24


/usr/bin/killall tncattach

sleep 5

/usr/local/bin/tncattach /dev/ttyUSB0 115200 -d -e -n -m 400 -i $1
/usr/sbin/tc qdisc add dev tnc0 root tbf rate 20kbit burst 32kbit latency 400ms

echo 1 > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -t nat -A POSTROUTING -o enp1s0 -j MASQUERADE
/sbin/iptables -A FORWARD -i enp1s0 -o tnc0 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i tnc0 -o enp1s0 -j ACCEPT
