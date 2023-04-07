#!/bin/bash -e

if [ ! "$#" -eq 3 ]; then
    echo -e "Usage:\n $0 pkg_file username host"
    exit 1
fi

PKG_FILE=${1}
USERNAME=${2}
HOST=${3}

ENVY_TEMP=/tmp/envy-temp/

# Generate package file
trap mkdir -p ${ENVY_TEMP}
tar -xzf ${PKG_FILE} -C ${ENVY_TEMP}
tar -czf /tmp/files.gz files/* ${ENVY_TEMP}/*

# Copy package file to server's temp directory
scp /tmp/files.gz ${USERNAME}@${HOST}:/tmp/

# Connect to server through SSH to apply the package
ssh ${USERNAME}@${HOST} << END
mkdir -p ${ENVY_TEMP}
tar -xzf /tmp/files.gz -C ${ENVY_TEMP}
bash ${ENVY_TEMP}/open-firewall.sh &

mv ${ENVY_TEMP}/dhcp.yaml /etc/netplan/
bash ${ENVY_TEMP}/apply-network.sh &
bash ${ENVY_TEMP}/install.sh
killall bash apply-network.sh

END