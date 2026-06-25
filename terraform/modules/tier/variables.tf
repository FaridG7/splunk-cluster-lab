variable "spec" {
  description = "Specification for the tier"
  type = object({
    name                = string
    pool                = string
    base_image_path     = string
    ssh_public_key_path = string
    network_address     = string
  })

}
