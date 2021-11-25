#!/bin/bash
##################################################################
# Step 3 : check connectivity                                    #
##################################################################
echo "-------------------------- "
echo ">>>>>>>> H1_1 : check connectivity towards 137.204.1.2"
echo ">>>>>>>> Works !"
ip netns exec h1_1 ping -c 5 137.204.1.2
ip netns exec h1_1 arp -n
echo ">>>>>>>> H1_2 : check connectivity towards 137.204.1.1"
echo ">>>>>>>> Works !"
ip netns exec h1_2 ping -c 5 137.204.1.1
ip netns exec h1_2 arp -n
echo ">>>>>>>> H1_1 : check connectivity towards 137.204.2.1"
ip netns exec h1_1 ping -c 5 137.204.2.1
ip netns exec h1_1 arp -n
echo ">>>>>>>> H1_2 : check connectivity towards 137.204.2.1"
ip netns exec h1_2 ping -c 5 137.204.2.1
ip netns exec h1_2 arp -n
