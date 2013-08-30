#!/bin/bash

MASTERFILE=/home/jeremy/master_fc6.img
cd /dev/VGXen
for i in $(ls); do
	/bin/dd if=$MASTERFILE of=/dev/VGXen/$i bs=1024000
	echo "copied to $i"
done
