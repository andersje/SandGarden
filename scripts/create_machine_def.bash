#!/bin/bash
# shell script to create the /etc/xen configuration file, based on:

### Automatically generated xen config file
## name = "StudentProtoB"
## memory = "256"
## disk = [ 'phy:/dev/sdc11,xvda,w', ]
## vif = [ 'mac=00:16:3e:06:5d:ee, bridge=xenbr0', ]
## nographic=1
## uuid = "3c7a1062-d287-c16d-8e3b-fc4a840ee3c6"
## bootloader="/usr/bin/pygrub"
## vcpus=1
## on_reboot   = 'restart'
## on_crash    = 'restart'

MACHINENAME=$1
TARGET=/etc/xen/$1

UUID_END=$(cat /etc/xen/last_uuid)
let UUID_END=UUID_END+1
UUID="3c7a1062-d287-c16d-8e3b-"$UUID_END

echo $UUID_END > /etc/xen/last_uuid

#begin code to autocreate MAC addresses
LASTIP=$(cat /etc/xen/lastip)
let NEXTIP=LASTIP+1
IP="10.10.60.$NEXTIP"

prelude_MAC="00:16:3e:06:5c:"
last_MAC_octet=$(echo "obase=16; $LASTIP" | bc)
FULLMAC="$prelude_MAC$last_MAC_octet"
#end code to autocreate MAC addresses

#begin code to automatically determine target partition
#LASTPART=$(cat /etc/xen/lastpartnum)
let NEXTPART=$NEXTIP
if [[ $NEXTPART -lt 10 ]]; then
	PARTNUM="00"$NEXTPART	
else
	if [[ $NEXTPART -lt 100 ]]; then
		PARTNUM="0"$NEXTPART	
	else
		let PARTNUM=$NEXTPART
	fi
fi

TARGETPART="/dev/VGXen/xen$PARTNUM"
echo "I am putting things in /dev/VGXen/$TARGETPART"

echo $PARTNUM > /etc/xen/lastpartnum

#end code to automatically determine target partition


cat >> $TARGET << END
## Configuration file generated by create_machine_def.bash
name = "$1"
memory = "256"
disk = [ 'phy:$TARGETPART,xvda,w', ]
vif = [ 'mac=$FULLMAC, bridge=xenbr0', ]
nographic=1
uuid = "$UUID"
bootloader="/usr/bin/pygrub"
vcpus=1
on_reboot   = 'restart'
on_crash    = 'restart'


END

echo "created configuration in /etc/xen/$1 -- verify it is correct"
cat >> dhcpd.addon << END
host $1 {
        hardware ethernet "$FULLMAC";
        fixed-address $IP;
        server-name "$1.htc-xen.org";
}
END

echo $NEXTIP > /etc/xen/lastip

echo "going to jda_dupe_single"
echo "./jda_dup_single.bash $TARGETPART '/home/jeremy/centos51.img'" >> buildparts.bash
