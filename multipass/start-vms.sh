#!/bin/bash

# to start multipass VMs

source "$(dirname "$0")/../cluster.env"

for NODE in "${NODES[@]}"; do
  read -r NAME _ _ _ _ _ <<< "$NODE"
  echo "Starting VM: $NAME"
  multipass start "$NAME"
done
