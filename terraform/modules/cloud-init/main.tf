resource "libvirt_cloudinit_disk" "init" {
  name = "${var.spec.name}-disk"
  user_data = templatefile("${path.module}/user-data.tftpl", {
    hostname       = var.spec.name
    ssh_public_key = trimspace(file(var.spec.ssh_public_key_path))
  })

  meta_data = templatefile("${path.module}/meta-data.tftpl", {
    hostname    = var.spec.name
    instance_id = var.spec.name
  })

  network_config = templatefile("${path.module}/network-config.tftpl", {
    ip_address    = var.spec.ip.address
    prefix_length = var.spec.ip.prefix_length
    gateway       = var.spec.ip.gateway
    dns           = var.spec.ip.dns
  })
}

resource "libvirt_volume" "this" {
  name = "${var.spec.name}-init"
  pool = var.spec.pool
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
