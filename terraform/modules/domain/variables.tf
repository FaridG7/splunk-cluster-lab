variable "spec" {
  description = "Specification for the VM"
  type = object({
    name            = string
    pool            = string
    base_image_path = string
    capacity        = number
    memory          = number
    vcpu            = number
    network_name    = string
    cloud_init = object({
      ssh_public_key_path = string
      ip = object({
        address       = string
        prefix_length = number
        gateway       = string
        dns           = string
      })
    })
  })
}
