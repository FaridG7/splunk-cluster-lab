resource "libvirt_volume" "this" {
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
    path = var.spec.base_volume_path
    format = {
      type = "qcow2"
    }
  }
}
