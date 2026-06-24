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

  name                = "mgmt"
  ssh_public_key_path = "../keys/id_rsa.pub"
  network_address     = "192.168.10.0/24"
}
