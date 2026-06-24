resource "libvirt_network" "this" {
  name = var.name
  ips = [{
    address = var.ips.address
    netmask = var.ips.netmask
  }]
}
