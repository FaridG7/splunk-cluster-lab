resource "libvirt_network" "this" {
  name = "${var.name}-net"
  ips = [{
    address = cidrhost(var.cidr_address, 0)
    netmask = cidrnetmask(var.cidr_address)
  }]
}
