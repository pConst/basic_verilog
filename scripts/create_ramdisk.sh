#!/bin/bash

mkdir -p /media/const/ramdisk
sudo chmod 777 /media/const/ramdisk
sudo mount -t tmpfs -o size=32768M tmpfs /media/const/ramdisk
cd /media/const/ramdisk

