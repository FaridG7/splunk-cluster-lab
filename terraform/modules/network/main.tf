resource "libvirt_network" "this" {
  name = "${var.spec.name}-net"
  ips = [{
    address = cidrhost(var.spec.cidr_address, 0)
    netmask = cidrnetmask(var.spec.cidr_address)
  }]
}
