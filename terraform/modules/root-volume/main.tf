resource "libvirt_volume" "base" {
  name = "${var.name}-base.qcow2"
  pool = "default"

  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      # url = "https://cloud-images.ubuntu.com/noble/20260518/noble-server-cloudimg-amd64.img"
      # url = "./iso/noble-server-cloudimg-amd64.img"
      url = var.base_image_path
    }
  }
}

resource "libvirt_volume" "root_disk" {
  name          = "${var.name}-root.qcow2"
  pool          = "default"
  capacity      = var.capacity
  capacity_unit = "G"
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
