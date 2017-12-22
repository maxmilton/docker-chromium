# Chromium In A Container

Launch an ephemeral chromium instance in a Docker container. It's likely this will only run on a Linux desktop with X11 compatibility.

Based on the [amazing work done by jessfraz](https://github.com/jessfraz/dockerfiles/blob/master/chromium/Dockerfile) but with many customisations for performance and security.

Uses a very opinionated set of chromium flags:
[https://github.com/MaxMilton/docker-chromium/blob/master/default-flags](https://github.com/MaxMilton/docker-chromium/blob/master/default-flags)

## Usage

### Build

```bash
docker build -t local/chromium .
```

### Run

_NOTE: The default page is `about:blank` for fast launch time._

```bash
./launch.sh
```

You can optionally pass an alternate Docker command:

```bash
./launch.sh http://localhost:8080 --allow-insecure-localhost
```

## Enabling persistence

> TL;DR — Uncomment code, see: `launch.sh`.

When run as is, the docker container is ephemeral so each time you launch an instance it's a completely fresh browser (useful for testing or as an incognito mode alternative). Browser data persistence is not enabled by default.

To make the container data persist edit the `launch.sh` file by commenting out the existing `docker run` and uncommenting the persistent docker run code. You can now sign in to create a profile etc.

The differences are:

1. Prevent removing container after exiting, so we don't need:

```bash
  --rm \
```

2. Mount host volumes to store the data:

_NOTE: The `:z` sets the correct SELinux role and allows read/write access._

```bash
  --volume "$HOME"/Downloads:/home/chromium/Downloads:z \
  --volume "$HOME"/.config/chromium/:/data:z \
```

## Additional considerations

1. Bug: Audio is sent to the default audio device and is not easily configurable.

2. Uses a custom set of chromium flags for improved security and performance: `default-flags`.

3. `--volume /dev/shm:/dev/shm` is necessary because Docker currently only allocates 64 MB of memory to /dev/shm but chromium needs a lot more to run without crashing. On some systems it my not be required. [More info](https://github.com/c0b/chrome-in-docker/issues/1).

## Licence

Released under the MIT licence; see [LICENCE](https://github.com/MaxMilton/docker-chromium/blob/master/LICENCE).

-----

© 2017 [We Are Genki](https://wearegenki.com)
