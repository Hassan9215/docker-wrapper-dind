#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Usage: docker-wrapper-dind <image> [args...]"
  exit 1
fi

image=$1
shift

# Run the container in detached mode, no logs shown
docker run -d "$image" "$@" >/dev/null

