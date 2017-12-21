# Run the Chromium browser in a container

FROM debian:testing-slim

RUN set -xe \
  && apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-l10n \
    fonts-liberation \
    fonts-roboto \
    fonts-symbola \
    hicolor-icon-theme \
    libcanberra-gtk-module \
    libexif-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpango1.0-0 \
    libpulse0 \
    libv4l-0 \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /etc/chromium.d/ \
  && /bin/echo -e 'export GOOGLE_API_KEY="AIzaSyCkfPOPZXDKNn8hhgu3JrA62wIgC93d44k"\nexport GOOGLE_DEFAULT_CLIENT_ID="811574891467.apps.googleusercontent.com"\nexport GOOGLE_DEFAULT_CLIENT_SECRET="kdloedMFGdGla2P1zacGjAQh"' > /etc/chromium.d/googleapikeys \
  # add chromium user and set directory permissions
  && groupadd -r -g 6006 chromium \
  && useradd -r -u 6006 -s /sbin/nologin -g chromium -G audio,video chromium \
  && mkdir -p /home/chromium/data \
  && mkdir -p /home/chromium/Downloads \
  && chown -R chromium:chromium /home/chromium \
  # unset SUID on all files
  && for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

# run as non privileged user
WORKDIR /home/chromium
USER chromium

ENTRYPOINT [ "/usr/bin/chromium" ]
CMD [ "about:blank", "--user-data-dir=/data", "--disable-breakpad", "--disable-clear-browsing-data-counters", "--disable-default-apps", "--disable-extensions", "--disable-ntp-popular-sites", "--disable-ntp-snippets", "--enable-fast-unload", "--enable-tcp-fastopen", "--no-default-browser-check", "--no-first-run", "--no-pings", "--password-store=basic", "--reduced-referrer-granularity", "--tls13-variant=draft", "--disable-gpu" ]
