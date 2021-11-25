#!/bin/bash
#######################################################################
# Step 1 : change Ip addressing from 2 network /24 to one network /22 #
#######################################################################
ip netns exec h1_2 ip addr delete 137.204.1.2 dev veth0
ip netns exec h1_2 ip addr delete 137.204.1.2/24 dev veth0
ip netns exec h1_1 ip addr add 137.204.1.1/22 dev veth0
ip netns exec h1_2 ip addr add 137.204.1.2/22 dev veth0
ip netns exec h1_2 ifconfig
ip netns exec h2_2 ifconfig
ip netns exec h2_2 ip add delete 137.204.2.2
ip netns exec h2_2 ifconfig
ip netns exec h2_2 ip add delete 137.204.2.2 dev veth0
ip netns exec h2_2 ifconfig
ip netns exec h2_2 ip addr add 137.204.2.2/22 dev veth0
ip netns exec h2_2 ifconfig
ip netns exec h1_2 ping -c 3 137.204.2.2
ip netns exec h1_2 route -n
