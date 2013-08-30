#!/bin/bash
DEBUG=1
for machine in $(virsh list | grep -v thing | grep -v Domain-0 | grep blocked | awk '{print $2}'); do
IS_ACTIVE=$(who | grep ^$machine | wc -l)
if [[ $DEBUG -gt 0 ]]; then
	logger "killer: detected the machine $machine active";
	logger "killer: I show that the user account associated with $machine has an active state of $IS_ACTIVE"
fi
if [[ $IS_ACTIVE -lt 1 ]]; then
	if [[ $DEBUG -gt 0 ]]; then
		logger "killer:  shutting down $machine"
	fi
	/usr/bin/virsh shutdown $machine
fi
done

