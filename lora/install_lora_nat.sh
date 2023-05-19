#!/bin/sh

# this take the evio network address and netmask for the lora_pendant node as the only argument
# e.g. install_lora_nat.sh 10.10.100.4/24
/usr/sbin/iptables -t nat -A POSTROUTING -s $1 -j MASQUERADE
