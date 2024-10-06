#!/usr/bin/env bash
set -e

IMAGE="ghcr.io/t2linux/fedora-silverblue:unstable"

mkdir output

cp config.toml .tmp-config.toml
sed -i "s@REPLACE_WITH_IMAGE_NAME@$IMAGE@g" .tmp-config.toml

podman pull "$IMAGE"

podman run --rm -it --privileged \
  --platform linux/amd64 \
  --security-opt label=type:unconfined_t \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  -v "$PWD/output":/output \
  -v "$PWD/.tmp-config.toml":/config.toml \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type anaconda-iso \
  --rootfs btrfs \
  --local \
  "$IMAGE"

mv output/bootiso/install.iso ./fedora-silverblue.iso
rm -rf output
