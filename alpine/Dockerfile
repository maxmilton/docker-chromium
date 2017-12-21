# Run the Chromium browser in a container

FROM alpine:edge

RUN set -xe \
  && apk add --no-cache \
    chromium \
    libcanberra-gtk3 \
  # add user and set directory permissions
  && addgroup -g 6006 -S chromium \
  && adduser -D -u 6006 -S -h /home/chromium -s /sbin/nologin -G chromium chromium \
  && addgroup chromium audio \
  && addgroup chromium video \
  # && mkdir -p /etc/chromium.d/ \
  && mkdir -p /home/chromium/data \
  && mkdir -p /home/chromium/Downloads \
  && chown -R chromium:chromium /home/chromium \
  # Unset SUID on all files
  && for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

# run as non privileged user
WORKDIR /home/chromium
USER chromium

ENTRYPOINT [ "/usr/bin/chromium-browser" ]
CMD [ "about:blank", "--user-data-dir=/data", "--disable-breakpad", "--disable-clear-browsing-data-counters", "--disable-default-apps", "--disable-extensions", "--disable-ntp-popular-sites", "--disable-ntp-snippets", "--enable-fast-unload", "--enable-tcp-fastopen", "--no-default-browser-check", "--no-first-run", "--no-pings", "--password-store=basic", "--reduced-referrer-granularity", "--tls13-variant=draft", "--disable-gpu" ]
