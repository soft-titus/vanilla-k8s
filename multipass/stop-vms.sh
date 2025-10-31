#!/bin/bash

# to stop multipass VMs

source "$(dirname "$0")/../cluster.env"

for NODE in "${NODES[@]}"; do
  read -r NAME _ _ _ _ _ <<< "$NODE"
  echo "Stopping VM: $NAME"
  multipass stop "$NAME"
done
