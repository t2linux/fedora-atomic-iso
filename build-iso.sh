#!/usr/bin/env bash
set -e

IMAGE="ghcr.io/t2linux/fedora-silverblue:43"
INSTALLER_IMAGE="ghcr.io/t2linux/fedora-silverblue-installer:43"

mkdir -p build

sudo podman pull "$IMAGE" "$INSTALLER_IMAGE"

sudo podman run --rm -it --privileged \
  --platform linux/amd64 \
  --privileged \
  --security-opt label=type:unconfined_t \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  -v "$PWD/build":/output \
  -v "$PWD/config.toml":/config.toml \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --in-vm \
  --use-librepo=True \
  --type bootc-installer \
  --rootfs btrfs \
  --bootc-installer-payload-ref "$IMAGE" \
  "$INSTALLER_IMAGE"
