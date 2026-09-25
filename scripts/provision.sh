#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "usage: $0 /dev/sdX"
    exit 2
}

[[ $# -eq 1 ]] || usage

disk=$1

### checks
if [[ ! -b "$disk" ]]; then
    echo "error: $disk is not a block device" >&2
    exit 1
fi

# mounted disk
if lsblk -rno MOUNTPOINT "$disk" | grep -q .; then
    echo "error: $disk or a partition on it is mounted" >&2
    exit 1
fi

# active swap on this disk
while IFS= read -r swapdev; do
    [[ -n "$swapdev" ]] || continue
    parent="/dev/$(lsblk -no PKNAME "$swapdev" 2>/dev/null || true)"
    if [[ "$swapdev" == "$disk" || "$parent" == "$disk" ]]; then
        echo "error: $swapdev is active swap on $disk" >&2
        exit 1
    fi
done < <(swapon --show=NAME --noheadings)

# LUKS/RAID/LVM membership
if lsblk -rno FSTYPE "$disk" | grep -qE '^(linux_raid_member|LVM2_member|crypto_LUKS)$'; then
    echo "error: $disk has an active RAID/LVM/LUKS member -- refusing to touch it" >&2
    exit 1
fi

### pretty summary
model=$(lsblk -dn -o MODEL "$disk" | xargs)
size=$(lsblk -dn -o SIZE "$disk" | xargs)

echo
echo "============================================================"
echo "                    DISK PROVISIONING"
echo "============================================================"
echo
echo "Target:"
echo "  Device: $disk"
echo "  Model:  ${model:-unknown}"
echo "  Size:   ${size:-unknown}"
echo
echo "Current layout:"
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS "$disk"
echo
echo "Existing signatures:"
wipefs --noheadings "$disk" || true
echo "\n============================================================\n"
echo "Warning: data on $disk will be erased."
echo "\nThe new partition table will be (GPT):\n"
echo "  1   1 GiB       EFI System Partition (FAT32)   PARTLABEL=EFI"
echo "  2   8 GiB       Linux swap                     PARTLABEL=SWAP"
echo "  3   remainder   Linux filesystem                PARTLABEL=ROOT"
echo "\n============================================================\n"

# get user confirmation
read -r -p "Type '$disk' to continue: " confirmation

if [[ "$confirmation" != "$disk" ]]; then
    echo "Aborted."
    exit 1
fi

echo -e "\nWiping existing signatures on $disk..."
wipefs -a "$disk"

echo -e "\nPartitioning $disk..."

sfdisk "$disk" <<EOF
label: gpt

size=1G, type=U, name="EFI"
size=8G, type=S, name="SWAP"
type=L, name="ROOT"
EOF

# wait for the kernel/udev to settle before touching the new partitions
echo -e "\nWaiting for udev event queue to clear...\n"
udevadm settle

# get partition names via sfdisk -d
# lines match "/dev/sdX1 : start=..., size=..., ...", 
parts=()
while IFS= read -r line; do
    [[ "$line" == /dev/* ]] && parts+=("${line%% *}")
done < <(sfdisk -d "$disk")

if [[ ${#parts[@]} -ne 3 ]]; then
    echo "error: expected 3 partitions on $disk, found ${#parts[@]}: ${parts[*]:-none}" >&2
    exit 1
fi

esp=${parts[0]}
swap_part=${parts[1]}
root=${parts[2]}

for p in "$esp" "$swap_part" "$root"; do
    if [[ ! -b "$p" ]]; then
        echo "error: expected partition $p not found after partitioning" >&2
        exit 1
    fi
done

echo -e "\nPartitioning complete.\n"
lsblk -o NAME,SIZE,TYPE,FSTYPE,PARTTYPE,PARTLABEL,MOUNTPOINTS "$disk"

echo -e "\nPartitions:"
echo "  ESP:   $esp"
echo "  Swap:  $swap_part"
echo "  Root:  $root"

echo -e "\nFormatting filesystems..."

mkfs.fat -F 32 "$esp"
mkswap -f "$swap_part"
mkfs.ext4 -F "$root"

echo
echo "============================================================"
echo "                    PROVISIONING COMPLETE"
echo "============================================================"
echo
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,PARTLABEL,UUID,MOUNTPOINTS "$disk"
echo
echo "ESP:   $esp"
echo "Swap:  $swap_part"
echo "Root:  $root"
echo
