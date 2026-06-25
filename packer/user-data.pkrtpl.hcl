#cloud-config
hostname: packer-builder
preserve_hostname: false

users:
  - name: packer
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_public_key}

ssh_pwauth: false
disable_root: true

runcmd:
  - systemctl enable --now ssh
