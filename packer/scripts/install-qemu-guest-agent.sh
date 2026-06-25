#!/bin/bash
set -euo pipefail

echo "==> Updating apt cache"
apt-get update -y

echo "==> Installing qemu-guest-agent"
apt-get install -y qemu-guest-agent

echo "==> Enabling qemu-guest-agent service"
systemctl enable qemu-guest-agent

echo "==> Done. qemu-guest-agent is baked into the image and will start on first boot."
