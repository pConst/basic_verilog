#!/bin/bash

#  iperf test.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com

# allows to test network performance on single local machine with two ports



# create namespaces to force linux to pass data through the cable
sudo ip netns add ns_server
sudo ip netns add ns_client
sudo ip link set enp1s0f0 netns ns_server
sudo ip netns exec ns_server ip addr add dev enp1s0f0 192.168.2.1/24
sudo ip netns exec ns_server ip link set dev enp1s0f0 up
sudo ip link set enp1s0f1 netns ns_client
sudo ip netns exec ns_client ip addr add dev enp1s0f1 192.168.2.2/24
sudo ip netns exec ns_client ip link set dev enp1s0f1 up

# start server (first terminal window)
sudo ip netns exec ns_server iperf -s 192.168.2.1

# start client (second termonal window)
sudo ip netns exec ns_client iperf -c 192.168.2.1 -d -i1 -t60

# remove namespaces
sudo ip netns del ns_server
sudo ip netns del ns_client

