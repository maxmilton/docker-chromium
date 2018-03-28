#!/bin/bash

# revoke X11 forwarding permission on exit
set -eo errtrace
trap 'xhost -local:$USER' EXIT

# directory of this script
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# allow X11 forwarding permission
xhost +local:"$USER"

# ------------------------------------------------- #

# minimal chromium; no persistence

docker run \
  --rm \
  --name chromium \
  --network host \
  --memory 2g \
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
  --cap-drop=all \
  --cap-add SYS_ADMIN \
  --security-opt no-new-privileges \
  --security-opt seccomp="$DIR"/seccomp.json \
  local/chromium $@
  # OR
  # maxmilton/chromium $@

# ------------------------------------------------- #

# chromium with persistence

# docker run \
#   --name chromium \
#   --network host \
#   --memory 2g \
#   --read-only \
#   --tmpfs /run:rw,nosuid,nodev \
#   --tmpfs /tmp:rw,nosuid,nodev \
#   --tmpfs /data:rw,noexec,nosuid,nodev,uid=6006,gid=6006,mode=0700 \
#   --tmpfs /home/chromium:rw,nosuid,nodev,uid=6006,gid=6006,mode=0700,size=4m \
#   --volume /dev/shm:/dev/shm \
#   --volume /etc/localtime:/etc/localtime:ro \
#   --volume /tmp/.X11-unix:/tmp/.X11-unix \
#   --volume "$HOME"/Downloads:/home/chromium/Downloads:z \
#   --volume "$HOME"/.config/chromium/:/data:z \
#   --device /dev/snd \
#   --device /dev/dri \
#   --device /dev/video0 \
#   --env DISPLAY=unix"$DISPLAY" \
#   --group-add audio \
#   --group-add video \
#   --cap-drop=all \
#   --cap-add SYS_ADMIN \
#   --security-opt no-new-privileges \
#   --security-opt seccomp="$DIR"/seccomp.json \
#   local/chromium $@
#   # OR
#   # maxmilton/chromium $@
