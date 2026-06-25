terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.8"
    }
  }
  required_version = "~> 1.15.6"
}

resource "libvirt_volume" "base" {
  name = "base.qcow2"
  pool = "default"

  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      url = "./iso/noble-server-cloudimg-amd64-qemu-guest-agent.qcow2"
    }
  }
}


module "tier" {
  source = "./modules/tier"

  spec = {
    name                = "idx"
    pool                = "default"
    base_volume_path    = libvirt_volume.base.path
    ssh_public_key_path = "../keys/id_rsa.pub"
    network_address     = "192.168.10.0/24"
    offset              = 100
    domain_count        = 2
  }
}
