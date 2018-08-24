#!/bin/bash

ip tuntap add lkl-tap mode tap
ip addr add 10.0.0.1/24 dev lkl-tap
ip link set lkl-tap up
sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -o venet0 -j MASQUERADE
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 6000:6010 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 443 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 9001 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 51221 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 14310 -j DNAT --to-destination 10.0.0.2
iptables -t nat -A PREROUTING -i venet0 -p tcp --dport 4443 -j DNAT --to-destination 10.0.0.2
