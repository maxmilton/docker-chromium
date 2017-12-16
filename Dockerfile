# REF: https://github.com/jessfraz/dockerfiles/blob/master/chromium/Dockerfile

# Run Chromium in a container
#
# docker run -it \
#	--net host \ # may as well YOLO
#	--cpuset-cpus 0 \ # control the cpu
#	--memory 512mb \ # max memory it can use
#	-v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
#	-e DISPLAY=unix$DISPLAY \
#	-v $HOME/Downloads:/home/chromium/Downloads \
#	-v $HOME/.config/chromium/:/data \ # if you want to save state
#	--security-opt seccomp=$HOME/chrome.json \
#	--device /dev/snd \ # so we have sound
#	-v /dev/shm:/dev/shm \
#	--name chromium \
#	local/chromium

FROM debian:buster-slim

# install Chromium
RUN set -xe \
  && apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-l10n \
    fonts-liberation \
    fonts-roboto \
    hicolor-icon-theme \
    libcanberra-gtk-module \
    libexif-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpango1.0-0 \
    libv4l-0 \
    fonts-symbola \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /etc/chromium.d/ \
  && /bin/echo -e 'export GOOGLE_API_KEY="AIzaSyCkfPOPZXDKNn8hhgu3JrA62wIgC93d44k"\nexport GOOGLE_DEFAULT_CLIENT_ID="811574891467.apps.googleusercontent.com"\nexport GOOGLE_DEFAULT_CLIENT_SECRET="kdloedMFGdGla2P1zacGjAQh"' > /etc/chromium.d/googleapikeys

RUN set -xe \
  # add chromium user
  && groupadd -r -g 6006 chromium \
  && useradd -r -u 6006 -s /sbin/nologin -g chromium -G audio,video chromium \
  && mkdir -p /home/chromium/data \
  && mkdir -p /home/chromium/Downloads \
  && chown -R chromium:chromium /home/chromium \
  # unset SUID on all files
  && for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

# run as non privileged user
USER chromium

ENTRYPOINT [ "/usr/bin/chromium" ]
CMD [ "--user-data-dir=/home/chromium/data", "--disable-breakpad", "--disable-clear-browsing-data-counters", "--disable-cloud-import", "--disable-default-apps", "--disable-extensions", "--disable-logging", "--disable-ntp-popular-sites", "--disable-sync", "--enable-fast-unload", "--enable-password-generation", "--enable-tcp-fastopen", "--fast", "--no-default-browser-check", "--no-first-run", "--no-pings", "--no-referrers", "--reduced-referrer-granularity", "--tls13-variant=draft", "--user-gesture-required" ]
