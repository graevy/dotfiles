#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

IFACE=$1

if ! ip link show "$IFACE" &>/dev/null; then
    echo "Interface $IFACE not found." >&2
    exit 1
fi

echo "Pinging all-nodes multicast on $IFACE to populate neighbor table..."
ping6 -c 3 -W 1 "ff02::1%${IFACE}" &>/dev/null || true

# grab the first reachable/stale link-local neighbor on this interface
PIKVM_ADDR=$(ip -6 neigh show dev "$IFACE" \
    | awk '$1 ~ /^fe80:/ && ($NF == "REACHABLE" || $NF == "STALE") {print $1; exit}')

if [[ -z "$PIKVM_ADDR" ]]; then
    echo "No reachable link-local neighbor found on $IFACE." >&2
    echo "Current neighbor table:" >&2
    ip -6 neigh show dev "$IFACE" >&2
    exit 1
fi

echo "Found PiKVM at ${PIKVM_ADDR}%${IFACE}, connecting..."
exec ssh "root@${PIKVM_ADDR}%${IFACE}"

