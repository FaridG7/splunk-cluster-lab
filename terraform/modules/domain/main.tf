module "root_volume" {
  source = "../root-volume"

  spec = {
    name            = var.spec.name
    pool            = var.spec.pool
    base_image_path = var.spec.base_image_path
    capacity        = var.spec.capacity
  }
}
module "cloud_init_volume" {
  source = "../cloud-init"

  spec = {
    name                = var.spec.name
    pool                = var.spec.pool
    ssh_public_key_path = var.spec.cloud_init.ssh_public_key_path
    ip = {
      address       = var.spec.cloud_init.ip.address
      prefix_length = var.spec.cloud_init.ip.prefix_length
      gateway       = var.spec.cloud_init.ip.gateway
      dns           = var.spec.cloud_init.ip.dns
    }
  }
}

resource "libvirt_domain" "webserver-vm" {
  name        = var.spec.name
  memory      = var.spec.memory
  memory_unit = "MiB"
  vcpu        = var.spec.vcpu
  type        = "kvm"
  running     = true

  os = {
    type = "hvm"
  }

  devices = {
    disks = [
      {
        driver = {
          name = "qemu"
          type = "qcow2"
        }
        source = {
          volume = {
            pool   = module.root_volume.pool
            volume = module.root_volume.name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      },
      {
        device = "cdrom"
        driver = {
          name = "qemu"
          type = "raw"
        }
        target = { dev = "sda", bus = "sata" }
        source = {
          volume = {
            pool   = module.cloud_init_volume.pool
            volume = module.cloud_init_volume.name
          }
        }
      }
    ]
    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = var.spec.network_name
          }
        }
        # wait_for_ip = {
        #   source  = "agent"
        #   timeout = 600
        # }
      }
    ]
    consoles = [
      {
        type = "pty"
        target = {
          type = "serial"
          port = 0
        }
      }
    ]
    channels = [
      {
        source = {
          unix = {
            mode = "bind"
          }
        }
        target = {
          virt_io = {
            name = "org.qemu.guest_agent.0"
          }
        }
      }
    ]
  }
}
