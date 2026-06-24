output "id" {
  value = libvirt_network.this.id
}
output "cidr_address" {
  # value = "${libvirt_network.this.ips[0].address}/${libvirt_network.this.ips[0].prefix}"
  value = var.cidr_address
}
output "gateway" {
  # value = cidrhost(libvirt_network.this.ips[0].address, 1)
  value = cidrhost(var.cidr_address, 1)
}
output "dns" {
  # value = libvirt_network.this.dns.host[0].ip
  value = cidrhost(var.cidr_address, 1)
}
