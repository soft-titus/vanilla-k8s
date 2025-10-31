#!/bin/bash

# to restart multipass VMs

source "$(dirname "$0")/../cluster.env"

for NODE in "${NODES[@]}"; do
  read -r NAME _ _ _ _ _ <<< "$NODE"
  echo "Restarting VM: $NAME"
  multipass restart "$NAME"
done
