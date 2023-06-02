#!/bin/sh

# This script is to be run in a fitlet2 gateway that is connected to a LoRa radio but not a cell link (e.g. at the FCR Weir)
# Note **run this script only if the fitlet serves as an EdgeVPN (evio) switch**
# If not using evio, run restart_lora_at_noevio_gateway.sh
# It configures the LoRa tnc0 interface, applies traffic control, and configures IP layer to route through the gateway it connects to
# It should run in crontab at boot time, and periodically (e.g. @hourly)

# this assumes the evio docker container is already running
# docker run -d -v /home/$USER/.evio/config.json:/etc/opt/evio/config.json -v /var/log/evio/:/var/log/evio/ --restart always --privileged --name evio-node --network host edgevpnio/evio-node:latest

# this takes the evio network address and netmask *of the lora_pendant node* as the only argument
# e.g. restart_lora_at_evio_switch.sh 10.10.100.8/24

# bring lora interface down and up
/usr/bin/killall tncattach

sleep 5

/usr/local/bin/tncattach /dev/ttyUSB0 115200 -d -e -n -m 400

# attach to evio bridge and throttle rate
/usr/bin/docker exec -it evio-node ovs-vsctl add-port appCIBR6 tnc0
/usr/bin/docker exec -it evio-node ovs-vsctl set interface tnc0 ingress_policing_rate=10
/usr/bin/docker exec -it evio-node ovs-vsctl set interface tnc0 ingress_policing_burst=10
/usr/sbin/tc qdisc add dev tnc0 root tbf rate 20kbit burst 32kbit latency 400ms

# enable IP forwarding
/usr/sbin/sysctl -w net.ipv4.ip_forward=1
/usr/sbin/iptables -t nat -A POSTROUTING -s $1 -j MASQUERADE