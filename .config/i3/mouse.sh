#!/bin/sh
set -euxo pipefail

device="SOAI USB Gaming Mouse"

id=$(xinput list --id-only "$device" 2>/dev/null)

if [ -n "$id" ]; then
	# xinput set-prop "$id" "libinput Accel Speed" -1.0
	xinput set-prop "$id" "Coordinate Transformation Matrix" \
		1 0 0 \
		0 1 0 \
		0 0 7
fi

