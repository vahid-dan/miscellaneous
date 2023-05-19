#!/bin/sh

# bring lora interface down and up
/usr/bin/killall tncattach
/usr/local/sbin/tncattach /dev/ttyUSB0 115200 -d -e -n -m 400 

# attach to evio bridge and throttle rate
/usr/bin/docker exec -it evio-node ovs-vsctl add-port appCIBR6 tnc0
/usr/bin/docker exec -it evio-node ovs-vsctl set interface tnc0 ingress_policing_rate=10
/usr/bin/docker exec -it evio-node ovs-vsctl set interface tnc0 ingress_policing_burst=10
/usr/sbin/tc qdisc add dev tnc0 root tbf rate 20kbit burst 32kbit latency 400ms

# enable IP forwarding
/usr/sbin/sysctl -w net.ipv4.ip_forward=1
