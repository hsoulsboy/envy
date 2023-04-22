#!/bin/bash

if [ ! "$#" -eq 3 ]; then
	echo "Usage: $0 interface ip mask"
	exit 1
fi

INTERFACE=${1}
IP=${2}
MASK=${3}

while true; do
    ifconfig ${INTERFACE} ${IP}/${MASK}
    sleep 2
done