resource "libvirt_network" "this" {
  name = "${var.spec.name}-net"
  forward = {
    mode = "open"
  }
  ips = [{
    address = cidrhost(var.spec.cidr_address, 1)
    netmask = cidrnetmask(var.spec.cidr_address)
  }]
}
