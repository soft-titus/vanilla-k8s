#!/bin/bash

# to delete multipass vms

source "$(dirname "$0")/../cluster.env"

for NODE in "${NODES[@]}"; do
  read -r NAME _ _ _ _ _ <<< "$NODE"
  echo "Deleting VM: $NAME"
  multipass delete "$NAME"
done

multipass purge

