#!/usr/bin/env bash
set -e

IMAGE="ghcr.io/t2linux/fedora-silverblue:43"
INSTALLER_IMAGE="ghcr.io/t2linux/fedora-silverblue-installer:43"

mkdir -p build

sudo podman run --rm -it --privileged \
  --platform linux/amd64 \
  --privileged \
  --security-opt label=type:unconfined_t \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  -v "$PWD/build":/output \
  ghcr.io/osbuild/image-builder-cli build \
    bootc-installer \
    --bootc-default-fs btrfs \
    --bootc-ref "$INSTALLER_IMAGE" \
    --bootc-installer-payload-ref "$IMAGE"

mv build/*-installer-x86_64/*.iso build/fedora-silverblue.iso
