resource "libvirt_volume" "base" {
  name = "${var.spec.name}-base.qcow2"
  pool = var.spec.pool

  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      url = var.spec.base_image_path
    }
  }
}

resource "libvirt_volume" "root_disk" {
  name          = "${var.spec.name}-root.qcow2"
  pool          = var.spec.pool
  capacity      = var.spec.capacity
  capacity_unit = "GiB"
  target = {
    format = {
      type = "qcow2"
    }
  }
  backing_store = {
    path = libvirt_volume.base.path
    format = {
      type = "qcow2"
    }
  }
}
