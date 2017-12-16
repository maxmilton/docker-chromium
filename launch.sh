#!/bin/bash

# revoke X11 forwarding permission on exit
set -eo errtrace
trap 'xhost -local:$USER' EXIT

# directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# random
# allow X11 forwarding permission
xhost +local:"$USER"

# TODO: Replacement for --net host
# TODO: Prevent dbus errors and crash

# minimal; no persistence or sound
docker run -it --rm \
  --name chromium \
  --net host \
  --cpuset-cpus 0 \
  --memory 512mb \
  --read-only \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:z \
  --env DISPLAY=unix"$DISPLAY" \
  --device /dev/snd \
  --volume /dev/shm:/dev/shm \
  --tmpfs /home/chromium:rw,noexec,nodev,nosuid,uid=6006,gid=6006,mode=0700,size=256m \
  --cap-drop=all \
  --security-opt no-new-privileges \
  --security-opt seccomp="$DIR"/chrome-seccomp.json \
  local/chromium
  # FIXME: Results in chromium not able to write to /home/chromium
  # --read-only \
