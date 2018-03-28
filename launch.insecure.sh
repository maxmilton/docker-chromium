#!/bin/bash
#
# README:
#   On Arch Linux this image wont't work out of the box and needs the extra
#   "--cap-add SYS_ADMIN" line plus some other removed. Since this is insecure
#   it's best to only run this launch script if truly necessary.
#

# revoke X11 forwarding permission on exit
set -eo errtrace
trap 'xhost -local:$USER' EXIT

# directory of this script
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# allow X11 forwarding permission
xhost +local:"$USER"

# minimal chromium; no persistence
docker run \
  --rm \
  --name chromium \
  --network host \
  --memory 2gb \
  --read-only \
  --tmpfs /run:rw,nosuid,nodev \
  --tmpfs /tmp:rw,nosuid,nodev \
  --tmpfs /data:rw,noexec,nosuid,nodev,uid=6006,gid=6006,mode=0700 \
  --tmpfs /home/chromium:rw,nosuid,nodev,uid=6006,gid=6006,mode=0700,size=4m \
  --volume /dev/shm:/dev/shm \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/snd \
  --device /dev/dri \
  --device /dev/video0 \
  --env DISPLAY=unix"$DISPLAY" \
  --group-add audio \
  --group-add video \
  --cap-add SYS_ADMIN \
  --security-opt seccomp="$DIR"/seccomp.json \
  local/chromium $@
  # --cap-drop=all \
  # --security-opt no-new-privileges \
