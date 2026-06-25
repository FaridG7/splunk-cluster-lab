terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.8"
    }
  }
  required_version = "~> 1.15.6"
}

module "tier" {
  source = "./modules/tier"

  spec = {
    name                = "idx"
    pool                = "default"
    base_image_path     = "./iso/noble-server-cloudimg-amd64-qemu-guest-agent.qcow2"
    ssh_public_key_path = "../keys/id_rsa.pub"
    network_address     = "192.168.10.0/24"
  }
}
