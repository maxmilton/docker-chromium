# Chromium In A Container

Launch an ephemeral chromium instance in a Docker container. Will likely only run on a Linux desktop with X11 compatibility.

Originally based on the amazing work done by jessfraz: [https://github.com/jessfraz/dockerfiles/blob/master/chromium/Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/chromium/Dockerfile)

Uses a very opinionated set of chromium launch switches, see reference: [https://peter.sh/experiments/chromium-command-line-switches/](https://peter.sh/experiments/chromium-command-line-switches/)

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
./launch.sh --user-data-dir=/data --allow-insecure-localhost
```

## Enabling persistence

When run as is the docker container is ephemeral so each time you launch an instance it's a completely fresh browser (useful for testing or as an incognito mode alternative). Browser data persistence is not enabled by default and requires extra steps.

These steps will make the container data persist. Edit the `launch.sh` file `docker run` as follows:

1. To prevent removing container after exiting, delete the line:

```bash
  --rm \
```

2. Mount host volumes to store the data; add:

_NOTE: The `:z` will set the correct SELinux role and allow read/write access._

```bash
  --volume "$HOME"/Downloads:/home/chromium/Downloads:z \
  --volume "$HOME"/.config/chromium/:/data:z \
```

## Licence

Released under the MIT licence; see [LICENCE](https://github.com/MaxMilton/docker-chromium/blob/master/LICENCE).

-----

© 2017 [We Are Genki](https://wearegenki.com)
