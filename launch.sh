#!/bin/bash

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
  --cpuset-cpus 0 \
  --memory 512mb \
  --read-only \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:z \
  --env DISPLAY=unix"$DISPLAY" \
  --device /dev/snd \
  --volume /dev/shm:/dev/shm:z \
  --tmpfs /run:rw,nosuid,nodev \
  --tmpfs /tmp:rw,nosuid,nodev \
  --tmpfs /data:rw,noexec,nosuid,nodev,uid=6006,gid=6006,mode=0700 \
  --tmpfs /home/chromium:rw,nosuid,nodev,uid=6006,gid=6006,mode=0700,size=4m \
  --cap-drop=all \
  --security-opt no-new-privileges \
  --security-opt seccomp="$DIR"/seccomp.json \
  local/chromium $@
