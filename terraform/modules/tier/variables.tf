variable "spec" {
  description = "Specification for the tier"
  type = object({
    name                = string
    pool                = string
    base_volume_path    = string
    ssh_public_key_path = string
    network_address     = string
    ip_offset           = optional(number, 100)
    domain_count        = number
    memory              = optional(number, 4096)
    vcpu                = optional(number, 4)
    capacity            = optional(number, 40)
  })

}
