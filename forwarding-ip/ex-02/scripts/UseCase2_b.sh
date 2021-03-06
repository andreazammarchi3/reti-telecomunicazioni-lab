#!/bin/bash
##################################################################
# Step 7 : set static route forward path                   #
##################################################################
ip netns exec GTW_12 route add -net 137.204.3.0/24 gw 192.168.0.2
ip netns exec GTW_12 route -n
ip netns exec h1_1 ping -c 3 137.204.3.1

##################################################################
# Step 8 : set static route backward path                   #
##################################################################
ip netns exec GTW_3 route add -net 137.204.1.0/24 gw 192.168.0.1
ip netns exec GTW_3 route -n
ip netns exec h1_1 ping -c 3 137.204.3.1