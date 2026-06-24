output "id" {
  value = libvirt_network.this.id
}
output "cidr_address" {
  value = var.cidr_address
}
output "gateway" {
  value = cidrhost(var.cidr_address, 1)
}
output "dns" {
  value = cidrhost(var.cidr_address, 1)
}
