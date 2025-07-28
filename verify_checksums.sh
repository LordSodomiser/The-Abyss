#!/usr/bin/env bash


if [ -f checksums.sha256 ]; then
    sha256sum --check checksums.sha256
else
    echo "Error: checksums.sha256 file not found!"
    exit 1
fi
