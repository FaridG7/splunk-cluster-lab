module "network" {
  source = "../network"

  name         = var.name
  cidr_address = var.network_address
}

module "cloud-init" {
  source = "../cloud-init/"

  name                = var.name
  ssh_public_key_path = var.ssh_public_key_path
  ip_address          = cidrhost(module.network.cidr_address, 100)
  prefix_length       = split("/", module.network.cidr_address)[1]
  gateway             = module.network.gateway
  dns                 = module.network.dns
}
