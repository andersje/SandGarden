#!/bin/bash
TARGETPARTITION=$1
MASTERFILE="/dev/VGXen/xen001"
/bin/dd if=$MASTERFILE of=$TARGETPARTITION bs=1024000
echo "copied to $1"
