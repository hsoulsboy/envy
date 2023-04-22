#!/bin/bash

IP=$1
MASK=$2
INTERFACE=$3

if [ ! "$#" -eq 3 ]; then
	echo "Usage: $0 interface ip mask"
	exit 1
fi

INTERFACE=${1}
IP=${2}
MASK=${3}

echo "Configuring ${INTERFACE} with IP address ${IP}/${MASK}"
sudo ip a add ${IP}/${MASK} dev ${INTERFACE}
