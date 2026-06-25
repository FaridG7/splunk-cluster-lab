packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1.1"
    }
  }
}

variable "iso_url" {
  type        = string
  description = "URL or local path to the Ubuntu Noble cloud image (qcow2)."
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "iso_checksum" {
  type        = string
  description = "Checksum source for the cloud image."
  default     = "file:https://cloud-images.ubuntu.com/noble/current/SHA256SUMS"
}

variable "vm_name" {
  type    = string
  default = "noble-server-cloudimg-amd64-qemu-guest-agent.qcow2"
}

variable "disk_size" {
  type    = string
  default = "10G"
}

variable "memory" {
  type    = number
  default = 2048
}

variable "cpus" {
  type    = number
  default = 2
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Public key injected into the build VM. Reuses the same key your Terraform cloud-init module already deploys."
  default     = "../keys/id_rsa.pub"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Private key matching ssh_public_key_path. Used by Packer to authenticate over SSH during the build."
  default     = "../keys/id_rsa"
}

variable "output_directory" {
  type    = string
  default = "output"
}

source "qemu" "noble" {
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum
  disk_image   = true

  output_directory = var.output_directory
  vm_name          = var.vm_name

  disk_size        = var.disk_size
  format           = "qcow2"
  disk_compression = true
  disk_interface   = "virtio"

  memory = var.memory
  cpus   = var.cpus

  accelerator = "kvm"
  headless    = true
  net_device  = "virtio-net"

  cd_label = "cidata"
  cd_content = {
    "meta-data" = ""
    "user-data" = templatefile("${path.root}/user-data.pkrtpl.hcl", {
      ssh_public_key = trimspace(file(var.ssh_public_key_path))
    })
  }

  communicator         = "ssh"
  ssh_username         = var.ssh_username
  ssh_private_key_file = var.ssh_private_key_path
  ssh_timeout          = "10m"
  shutdown_command     = "sudo shutdown -P now"
}

build {
  name    = "noble-qemu-guest-agent"
  sources = ["source.qemu.noble"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E sh -c '{{ .Path }}'"
    scripts = [
      "${path.root}/scripts/install-qemu-guest-agent.sh",
      "${path.root}/scripts/cleanup.sh",
    ]
  }
}
