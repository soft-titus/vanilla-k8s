#!/bin/bash

# to generate netplan configuration for the bridge network

set -euo pipefail

source "$(dirname "$0")/../cluster.env"
export BRIDGE_NAME BRIDGE_CIDR

TEMPLATE="$(dirname "$0")/99-k8s-bridge-template.yaml"
OUTPUT_PATH="$(dirname "$0")/99-k8s-bridge.yaml"

echo "Generating Netplan configuration using:"
echo "  Bridge Name: ${BRIDGE_NAME}"
echo "  Bridge CIDR: ${BRIDGE_CIDR}"
echo

# Generate YAML file
envsubst < "${TEMPLATE}" > "${OUTPUT_PATH}"

echo "Netplan configuration generated at: ${OUTPUT_PATH}"
echo
echo "To apply the configuration on the host, run:"
echo "  sudo cp ${OUTPUT_PATH} /etc/netplan/99-k8s-bridge.yaml"
echo "  sudo netplan apply"
