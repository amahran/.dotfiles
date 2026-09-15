#!/usr/bin/env bash
#
# link2c-static-frame.sh
#
# Stops the Insta360 Link 2C "Auto Framing" by asserting a static PTZ frame.
# Writing the default pan/tilt/zoom drops the camera out of auto-framing at
# runtime. No persisted setting is changed, so there is nothing to undo:
# to get auto-framing back, show your palm to the lens (green light flashes)
# or replug the camera.
#
# Resolves the capture node via /dev/v4l/by-id/ so it survives reboots and
# changing /dev/videoN numbering.

set -euo pipefail

DEV=""

# Primary: stable by-id symlink. "-video-index0" is the capture function.
for link in /dev/v4l/by-id/*Insta360*-video-index0; do
    [ -e "$link" ] || continue
    DEV="$link"
    break
done

# Fallback: scan /dev/video* for an Insta360 node that actually reports formats
# (i.e. a real capture node, not a metadata node).
if [ -z "$DEV" ]; then
    for v in /dev/video*; do
        [ -e "$v" ] || continue
        if v4l2-ctl -d "$v" --info 2>/dev/null | grep -qi insta360 \
           && v4l2-ctl -d "$v" --list-formats-ext 2>/dev/null | grep -q '\[0\]'; then
            DEV="$v"
            break
        fi
    done
fi

if [ -z "$DEV" ]; then
    echo "link2c-static-frame: Insta360 Link 2C not found" >&2
    command -v notify-send >/dev/null && \
        notify-send -u critical "Link 2C" "Camera not found"
    exit 1
fi

v4l2-ctl -d "$DEV" --set-ctrl=zoom_absolute=100,pan_absolute=0,tilt_absolute=0

echo "link2c-static-frame: Auto Framing disabled on $DEV"
command -v notify-send >/dev/null && \
    notify-send "Link 2C" "Auto Framing disabled"
