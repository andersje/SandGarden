#!/bin/bash
#shell script to automate starting of a xen virtual machine
# at user login.  If the machine is already running, we'll
# detect that and simply connect to it.

if [[ -r /home/$USER/.xen.target_user ]]; then
	XENUSR=$(cat /home/$USER/.xen.target_user)
else
	XENUSR=student
fi

if [[ -r /etc/xen/$USER ]]; then
	ACTIVE=$(/usr/bin/virsh list | /bin/grep $USER | /usr/bin/wc -l)

	if [[ $ACTIVE -gt 0 ]]; then
		#this machine is already up.  We'll ssh to it.
		ssh -X $XENUSR@$USER.htc-xen.org
	else 
		#the system is not currently online
		#we'd best start it
		#sudo /usr/sbin/xm create StudentProtoB -c
		COMMAND="/usr/local/bin/start_xen.bash $USER"
		exec sudo $COMMAND
		#sudo /usr/local/bin/start_xen.bash 
	fi	
else
	echo "Sorry, I cannot read the configuration file (/etc/xen/$USER) for your virtual machine.  Contact the Instructor or system administrator for help."
	exit 0
fi
