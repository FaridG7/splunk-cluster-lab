module "network" {
  source = "../network"

  spec = {
    name         = var.spec.name
    cidr_address = var.spec.network_address
  }
}
module "domain" {
  source = "../domain/"

  count = var.spec.domain_count

  spec = {
    name             = "${var.spec.name}-${count.index}"
    pool             = var.spec.pool
    base_volume_path = var.spec.base_volume_path
    capacity         = var.spec.capacity
    memory           = var.spec.memory
    vcpu             = var.spec.vcpu
    network_name     = module.network.name
    cloud_init = {
      ssh_public_key_path = var.spec.ssh_public_key_path
      ip = {
        address       = cidrhost(module.network.cidr_address, var.spec.offset + count.index)
        prefix_length = split("/", module.network.cidr_address)[1]
        gateway       = module.network.gateway
        dns           = module.network.dns
      }
    }
  }
}
