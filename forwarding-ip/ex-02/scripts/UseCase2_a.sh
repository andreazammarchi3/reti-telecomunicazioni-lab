#!/bin/bash
##################################################################
# Step 1 : create the hosts of the LANs to be connected to R1    #
##################################################################
for N in 1 2 3
do
	for H in 1 2
	do
		NH="h"$N"_"$H
		ip netns add $NH
		ip link add veth0 type veth peer name eth-$NH
		ip link set veth0 netns $NH
		ip netns exec $NH ip link set veth0 up
		ip netns exec $NH ip addr add 137.204.$N.$H/24 dev veth0
		MS="Host "$NH" done" 
		echo $MS
	done
	ip link add LAN$N type bridge
	ip link set LAN$N up
	for H in 1 2
	do
		NH="h"$N"_"$H
		ip link set eth-$NH master LAN$N
		ip link set eth-$NH up
	done
	bridge link
done
##################################################################
# Step 2 : create the gateway between LAN1 and LAN2              #
##################################################################
ip netns add GTW_12
for N in 1 2
do
	ip link add veth$N type veth peer name eth_G$N
	ip link set veth$N netns GTW_12
	ip netns exec GTW_12 ip link set veth$N up
	ip netns exec GTW_12 ip addr add 137.204.$N.254/24 dev veth$N
	ip link set eth_G$N master LAN$N
	ip link set eth_G$N up
done
bridge link
for N in 1 2
do
	for H in 1 2
	do
		NH="h"$N"_"$H
		ip netns exec $NH ip route add default via 137.204.$N.254 
	done
done
##################################################################
# Step 3 : create the gateway for LAN3                           #
##################################################################
ip netns add GTW_3
for N in 3
do
	ip link add veth$N type veth peer name eth_G$N
	ip link set veth$N netns GTW_3
	ip netns exec GTW_3 ip link set veth$N up
	ip netns exec GTW_3 ip addr add 137.204.$N.254/24 dev veth$N
	ip link set eth_G$N master LAN$N
	ip link set eth_G$N up
done
bridge link
for N in 3
do
	for H in 1 2
	do
		NH="h"$N"_"$H
		ip netns exec $NH ip route add default via 137.204.$N.254 
	done
done

##################################################################
# Step 3 : enable forwarding on gateways                         #
##################################################################
ip netns exec GTW_12 sysctl -w net.ipv4.ip_forward=1
ip netns exec GTW_3 sysctl -w net.ipv4.ip_forward=1

##################################################################
# Step 4 : create LAN between gateways                         #
##################################################################
ip link add LAN_G type bridge
ip link set LAN_G up
ip link add vethg type veth peer name eth-G_12
ip link set vethg netns GTW_12
ip netns exec GTW_12 ip link set vethg up
ip netns exec GTW_12 ip addr add 192.168.0.1/30 dev vethg
ip link set eth-G_12 master LAN_G
ip link set eth-G_12 up
ip link add vethg type veth peer name eth-G_3
ip link set vethg netns GTW_3
ip netns exec GTW_3 ip link set vethg up
ip netns exec GTW_3 ip addr add 192.168.0.2/30 dev vethg
ip link set eth-G_3 master LAN_G
ip link set eth-G_3 up
bridge link

##################################################################
# Step 5 : check connectivity between gateways                   #
##################################################################
ip netns exec GTW_12 ping -c 3 192.168.0.2
ip netns exec GTW_3 ping -c 3 192.168.0.1

##################################################################
# Step 6 : check connectivity between hosts                   #
##################################################################
ip netns exec h1_1 ping -c 3 137.204.2.1
ip netns exec h1_1 ping -c 3 137.204.3.1
sleep 10

