# Run the Chromium browser in a container
#
# Build or update image:
#   docker build --no-cache -t local/chromium .
#

FROM alpine:edge@sha256:79c2c5f6db53da44f90bb2731f29f725b5b14c378407a123776b6d3c76e6aebe

RUN set -xe \
  && addgroup -g 6006 -S chromium \
  && adduser -D -u 6006 -S -h /home/chromium -s /sbin/nologin -G chromium chromium \
  && adduser chromium audio \
  && adduser chromium video \
  && apk add --no-cache \
    chromium \
    libcanberra-gtk3 \
    mesa-dri-intel \
    mesa-gl

# override default launcher
COPY chromium /usr/lib/chromium/chromium-launcher.sh

# custom chromium flags
COPY default.conf /etc/chromium/default.conf

# run as non privileged user
USER chromium

ENTRYPOINT ["/usr/bin/chromium-browser"]
CMD ["about:blank"]
