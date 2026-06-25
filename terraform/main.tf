terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.8"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
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
  source   = "./modules/tier"
  for_each = { for t in var.tiers : t.name => t }

  spec = {
    name                = each.value.name
    network_address     = each.value.network_address
    ip_offset           = each.value.ip_offset
    domain_count        = each.value.domain_count
    memory              = each.value.memory
    vcpu                = each.value.vcpu
    capacity            = each.value.capacity
    pool                = var.pool
    ssh_public_key_path = var.ssh_keys.public_key_path
    base_volume_path    = libvirt_volume.base.path
  }
}
