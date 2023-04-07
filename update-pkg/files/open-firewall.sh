#!/bin/bash

while true; do
    iptables -F;
    iptables -P INPUT ACCEPT
    sleep 2
done