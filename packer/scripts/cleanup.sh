#!/bin/bash
set -euo pipefail

apt-get clean
rm -rf /var/lib/apt/lists/*

truncate -s 0 /etc/machine-id
if [ -f /var/lib/dbus/machine-id ]; then
  rm -f /var/lib/dbus/machine-id
  ln -s /etc/machine-id /var/lib/dbus/machine-id
fi

rm -f /etc/ssh/ssh_host_*

cloud-init clean --logs || true
rm -rf /var/lib/cloud/instances/*

find /var/log -type f -exec truncate -s 0 {} \;
rm -f /root/.bash_history /home/*/.bash_history

dd if=/dev/zero of=/EMPTY bs=1M || true
rm -f /EMPTY
sync
