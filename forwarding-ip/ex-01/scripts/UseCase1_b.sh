#!/bin/bash
##################################################################
# Step 1 : check hosts configuration                           #
##################################################################
for N in 1 2
do 
	echo "IP Network 137.204."$N".0/24"
	for H in 1 2 
	do
		NH="h"$N"_"$H
		echo "------------- "$NH" ------------- "
		echo "Check interface configuration"
		ip netns exec $NH ip addr
		echo "Check routing table"
		ip netns exec $NH route -n
		echo "Check interface configuration"
		ip netns exec $NH arp -n
		sleep 10
	done
done
