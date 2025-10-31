#!/bin/bash

# Purpose: Disable bridge packet filtering so Multipass instances
#          on the same bridge network can communicate with each other.
#          Applied via networkd-dispatcher to persist after reboot.
#
# Instructions:
# 1. Copy this script to /etc/networkd-dispatcher/routable.d/10-bridge-nf-fix.sh
# 2. Make it executable:
#       sudo chmod a+x /etc/networkd-dispatcher/routable.d/10-bridge-nf-fix.sh
# 3. Execute this script to apply settings immediately for the current session:
#       sudo /etc/networkd-dispatcher/routable.d/10-bridge-nf-fix.sh

# Apply settings for the current session
sudo sysctl -w net.bridge.bridge-nf-call-iptables=0
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=0
