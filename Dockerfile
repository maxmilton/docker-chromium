# Run the Chromium browser in a container
#
# Build image:
#   docker build -t local/chromium .
#
# Update:
#   docker build --no-cache -t local/chromium .
#

FROM alpine:edge

RUN set -xe \
  && addgroup -g 6006 -S chromium \
	&& adduser -D -u 6006 -S -h /home/chromium -s /sbin/nologin -G chromium chromium \
  && apk add --no-cache \
    chromium \
    libcanberra-gtk3 \
  # unset SUID on all files
  && for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

# override default launcher
COPY chromium /usr/lib/chromium/chromium-launcher.sh

# custom chromium flags
COPY default.conf /etc/chromium/default.conf

# run as non privileged user
USER chromium

ENTRYPOINT ["/usr/bin/chromium-browser"]
CMD ["about:blank"]
