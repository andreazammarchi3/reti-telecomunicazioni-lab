#!/bin/bash
##################################################################
# Step 1 : create gateway connected to LAN                       #
##################################################################
ip netns add GW
ip link add veth0 type veth peer name eth-g1
ip link add veth1 type veth peer name eth-g2
ip link set veth0 netns GW
ip link set veth1 netns GW
ip netns exec GW ip link set veth0 up
ip netns exec GW ip link set veth1 up
ip netns exec GW ifconfig
ip link set eth-g1 master LAN
ip link set eth-g2 master LAN
ip link set eth-g1 up
ip link set eth-g2 up
bridge link
##################################################################
# Step 2 : configure default gateway in hosts                    #
##################################################################
ip netns exec GW ip addr add 137.204.1.254/24 dev veth0
ip netns exec GW ip addr add 137.204.2.254/24 dev veth1
ip netns exec GW ifconfig
##################################################################
# Step 3 : enable IP packet forwarding in gateway                #
##################################################################
ip netns exec GW sysctl -r net.ipv4.ip_forward
ip netns exec GW sysctl -w net.ipv4.ip_forward=1
ip netns exec GW sysctl -r net.ipv4.ip_forward
