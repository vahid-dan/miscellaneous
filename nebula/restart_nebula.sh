#!/bin/sh

/usr/bin/killall nebula
nohup /etc/nebula/nebula -config /etc/nebula/config.yaml > /var/log/nebula.log &
