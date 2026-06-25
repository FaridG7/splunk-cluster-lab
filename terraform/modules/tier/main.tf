module "network" {
  source = "../network"

  spec = {
    name         = var.spec.name
    cidr_address = var.spec.network_address
  }
}
module "domain" {
  source = "../domain/"

  spec = {
    name            = var.spec.name
    pool            = var.spec.pool
    base_image_path = var.spec.base_image_path
    capacity        = 40
    memory          = 4096
    vcpu            = 4
    network_name    = module.network.name
    cloud_init = {
      ssh_public_key_path = var.spec.ssh_public_key_path
      ip = {
        address       = cidrhost(module.network.cidr_address, 100)
        prefix_length = split("/", module.network.cidr_address)[1]
        gateway       = module.network.gateway
        dns           = module.network.dns
      }
    }
  }
}
