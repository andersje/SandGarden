#!/bin/bash
#shell script to automate starting of a xen virtual machine
# at user login.  If the machine is already running, we'll
# detect that and simply connect to it.
# proper username is the first argument
sudo /usr/sbin/xm create $1 -c
