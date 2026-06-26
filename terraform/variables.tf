variable "tiers" {
  description = "Specification for the tiers"
  type = list(object({
    name            = string
    network_address = string
    ip_offset       = optional(number, 100)
    domain_count    = number
    memory          = optional(number, 4096)
    vcpu            = optional(number, 4)
    capacity        = optional(number, 40)
  }))
}
variable "pool" {
  description = "The pool used for storing the volumes. (this pool must be defined already)"
  type        = string
  default     = "default"
}
variable "ssh_keys" {
  description = "The path to the public & private keys that are used for ssh"
  type = object({
    private_key_path = string
    public_key_path  = string
  })
}
variable "ansible_inventory_path" {
  description = "Path where the Ansible inventory file will be written"
  type        = string
  default     = "../ansible/inventory/hosts.ini"
}
