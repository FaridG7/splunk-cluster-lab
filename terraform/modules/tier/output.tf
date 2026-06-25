output "domains" {
  description = "Map of domain name to IP address for each domain in this tier"
  value = {
    for i in range(var.spec.domain_count) :
    "${var.spec.name}-${i}" => cidrhost(var.spec.network_address, var.spec.ip_offset + i)
  }
}
