#!/bin/bash
#/etc/xen/student_machines must be a text file containing, in order
# machine_name partition_name MAC_ADDRESS
for entry in $(awk '{print $1}' /etc/xen/student_machines | grep -v ^# ); do
	echo "entry is $entry"
	if [[ ! -f /etc/xen/$entry ]]; then
	echo "creating $entry"
	sleep 1
		FULLENTRY=$(grep ^$entry /etc/xen/student_machines);
		echo "tried grep ^$entry /etc/xen/student_machines"
		echo "calling create_machine_def.bash $FULLENTRY"
		./create_machine_def.bash $FULLENTRY
		PARTNAME=$(grep ^$entry /etc/xen/student_machines | awk '{print $2}')
		#time to do the DNS stuff
		./create_lookup.bash
	fi
done
