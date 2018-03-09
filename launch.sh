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
  --cpuset-cpus 0,1 \
  --memory 1g \
  --read-only \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:z \
  --env DISPLAY=unix"$DISPLAY" \
  --volume /dev/shm:/dev/shm:z \
  --tmpfs /run:rw,nosuid,nodev \
  --tmpfs /tmp:rw,nosuid,nodev \
  --tmpfs /data:rw,noexec,nosuid,nodev,uid=6006,gid=6006,mode=0700 \
  --tmpfs /home/chromium:rw,nosuid,nodev,uid=6006,gid=6006,mode=0700,size=4m \
  --cap-drop=all \
  --security-opt no-new-privileges \
  --security-opt seccomp="$DIR"/seccomp.json \
  local/chromium $@
  # TODO: Get audio working correctly cross-OS
  # --group-add "$(getent group audio | cut -d: -f3)" \
  # --device /dev/snd \

# ------------------------------------------------- #

# chromium with persistence

# docker run \
#   --name chromium \
#   --network host \
#   --cpuset-cpus 0,1 \
#   --memory 1g \
#   --read-only \
#   --volume /tmp/.X11-unix:/tmp/.X11-unix:z \
#   --env DISPLAY=unix"$DISPLAY" \
#   --group-add "$(getent group audio | cut -d: -f3)" \
#   --device /dev/snd \
#   --volume "$HOME"/Downloads:/home/chromium/Downloads:z \
#   --volume "$HOME"/.config/chromium/:/data:z \
#   --volume /dev/shm:/dev/shm:z \
#   --tmpfs /run:rw,nosuid,nodev \
#   --tmpfs /tmp:rw,nosuid,nodev \
#   --tmpfs /data:rw,noexec,nosuid,nodev,uid=6006,gid=6006,mode=0700 \
#   --tmpfs /home/chromium:rw,nosuid,nodev,uid=6006,gid=6006,mode=0700,size=4m \
#   --cap-drop=all \
#   --security-opt no-new-privileges \
#   --security-opt seccomp="$DIR"/seccomp.json \
#   local/chromium $@
