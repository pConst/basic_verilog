#!/bin/bash
# the script adds 32GB of permanent swap space

sudo fallocate -l 32G /swap32
sudo chmod 600 /swap32
sudo mkswap /swap32
sudo swapon /swap32
echo '/swap32 none swap sw 0 0' | sudo tee -a /etc/fstab

