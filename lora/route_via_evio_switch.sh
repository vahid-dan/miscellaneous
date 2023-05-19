#!/bin/sh

# this takes only one argument, which is the evio IP address of the evio_switch gateway
# e.g. route_via_evio_switch.sh 10.10.100.7

/usr/sbin/ip route delete default
/usr/sbin/ip route add default via $1
