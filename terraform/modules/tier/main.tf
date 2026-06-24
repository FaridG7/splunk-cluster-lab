module "network" {
  source = "../network"

  name = "${var.name}-net"
  ips = {
    address = "192.168.10.0"
    netmask = "255.255.255.0"
  }
}

