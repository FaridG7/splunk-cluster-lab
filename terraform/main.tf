terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.8"
    }
  }
  required_version = "~> 1.15.6"
}

resource "libvirt_network" "splunk-mgmt-net" {
  name = "splunk-mgmt-net"
}

resource "libvirt_network" "splunk-idx-net" {
  name = "splunk-idx-net"
}

resource "libvirt_network" "splunk-sh-net" {
  name = "splunk-sh-net"
}

resource "libvirt_network" "splunk-lb-net" {
  name = "splunk-lb-net"
}
