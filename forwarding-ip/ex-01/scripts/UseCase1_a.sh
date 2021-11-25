#!/bin/bash
for N in 1 2
do 
	echo "IP Network 1"
	for H in 1 2 
	do
		echo "Create Hosts and configure IP and Netmask"
		NH="h"$N"_"$H
		ip netns add $NH
		ip link add veth0 type veth peer name eth-$NH
		ip link set veth0 netns $NH
		ip netns exec $NH ip link set veth0 up
		ip netns exec $NH ip addr add 137.204.$N.$H/24 dev veth0
		echo "------------- "$NH" ------------- "
	done
done
#################################################################
# Step 2 : create LAN bridge and connect                        #
##################################################################
ip link add LAN type bridge
ip link set LAN up
echo "-------------------------- "
echo "Create switch (name LAN) and connect hosts"
for N in 1 2
do
	for H in 1 2
	do
		NH="h"$N"_"$H
		ip link set eth-$NH master LAN
		ip link set eth-$NH up
	done
done
echo "Check interface status of LAN"
bridge link
