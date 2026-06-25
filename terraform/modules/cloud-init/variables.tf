variable "spec" {
  description = "Specification for the cloud-init config"
  type = object({
    name                = string
    pool                = string
    ssh_public_key_path = string
    ip = object({
      address       = string
      prefix_length = number
      gateway       = string
      dns           = string
    })
  })

}
