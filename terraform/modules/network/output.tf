output "name" {
  value = "${var.spec.name}-net"

}
output "cidr_address" {
  value = var.spec.cidr_address
}
output "gateway" {
  value = cidrhost(var.spec.cidr_address, 1)
}
output "dns" {
  value = cidrhost(var.spec.cidr_address, 1)
}
