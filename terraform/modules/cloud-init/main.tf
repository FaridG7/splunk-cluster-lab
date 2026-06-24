resource "libvirt_cloudinit_disk" "init" {
  name = "${var.name}-disk"
  user_data = templatefile("${path.module}/user-data.tftpl", {
    hostname       = var.name
    ssh_public_key = trimspace(file(var.ssh_public_key_path))
  })

  meta_data = templatefile("${path.module}/meta-data.tftpl", {
    hostname    = var.name
    instance_id = var.name
  })

  network_config = templatefile("${path.module}/network-config.tftpl", {
    ip_address    = var.ip_address
    prefix_length = var.prefix_length
    gateway       = var.gateway
    dns           = var.dns
  })
}

resource "libvirt_volume" "this" {
  name = "${var.name}-init"
  pool = "default"
  target = {
    format = {
      type = "iso"
    }
  }

  create = {
    content = {
      url = libvirt_cloudinit_disk.init.path
    }
  }
}
