#!/bin/bash

# to launch multipass VMs with specified resource configuration

set -euo pipefail

source "$(dirname "$0")/../cluster.env"
export SSH_PUBLIC_KEY_PATH BRIDGE_NAME K8S_POD_CIDR NODE_OS_VERSION NODES

TEMPLATE="$(dirname "$0")/cloud-init-template.yaml"

SSH_PUBLIC_KEY=$(cat ${SSH_PUBLIC_KEY_PATH})

for NODE in "${NODES[@]}"; do
  read -r NAME MAC IP CPUS MEMORY DISK <<< "$NODE"

  # Generate cloud-init YAML for this node
  CLOUD_INIT_FILE="$(dirname "$0")/cloud-init-${NAME}.yaml"
  SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY" \
  MAC_ADDRESS="$MAC" \
  NODE_IP_ADDRESS="$IP" \
  K8S_POD_CIDR="$K8S_POD_CIDR" \
    envsubst < "$TEMPLATE" > "$CLOUD_INIT_FILE"

  # Launch the Multipass instance with node-specific resources
  multipass launch "${NODE_OS_VERSION}" \
  --timeout 1800 \
    --name "$NAME" \
    --cpus "$CPUS" \
    --memory "$MEMORY" \
    --disk "$DISK" \
    --cloud-init "$CLOUD_INIT_FILE" \
    --network name=${BRIDGE_NAME},mode=manual,mac="$MAC"
    
  # Delete the generated cloud-init YAML
  rm -f "$CLOUD_INIT_FILE"
done
