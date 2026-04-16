#!/bin/sh
set -euxo pipefail

device="SOAI USB Gaming Mouse"

id=$(xinput list --id-only "$device" 2>/dev/null)

if [ -n "$id" ]; then
	xinput set-prop "$id" "libinput Accel Speed" -1.0
fi

