#!/bin/bash

# Define the log file
LOG_FILE="/var/log/modify-router.log"

# Log the start of the script
echo "$(date) - Script started" >> "$LOG_FILE"

while ! ip route show | grep -q "10.42.2.0/24 dev flannel.1 onlink"; do
    echo "$(date) - Waiting for route 10.42.2.0/24 dev flannel.1 onlink to exist..." >> "$LOG_FILE"
    sleep 1
done

ip route del 10.42.2.0/24 dev flannel.1 onlink
ip route add 10.42.2.0/24 via 192.168.56.33 dev enp0s8 

# Log the completion
echo "$(date) - Route modification completed" >> "$LOG_FILE"