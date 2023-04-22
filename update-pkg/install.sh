#!/bin/bash -e

if [ ! "$#" -eq 4 ]; then
    echo -e "Usage: $0 package username password host"
    exit 1
fi

PKG=${1}
USER=${2}
PW=${3}
HOST=${4}

# Copy package file to server's temp directory
scp ${PKG} ${USER}@${HOST}:/tmp/

# Network address configuration
read -p "Enter the interface name: " INTERFACE
read -p "Enter ip address: " IP
read -p "Enter the mask (cidr): " MASK


trap "echo -e '\nDisconnected from ssh'; exit" SIGINT

# Connect through SSH to apply the package
ssh -T ${USER}@${HOST} << END
mkdir -p /tmp/envy
tar xzf /tmp/files.gz -C /tmp/envy
echo ${PW} | sudo -S bash /tmp/envy/files/open-firewall.sh &
echo ${PW} | sudo -S bash /tmp/envy/files/apply-network.sh ${INTERFACE} ${IP} ${MASK}
rm -r /tmp/envy
exit
END