#!/usr/bin/env bash

find . -type f -not -path "./.git/*" -not -name "checksums.sha256" -exec sha256sum {} \; > checksums.sha256
echo "Checksums generated and saved to checksums.sha256"
