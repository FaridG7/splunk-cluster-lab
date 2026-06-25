variable "spec" {
  description = "Specification for the root volume"
  type = object({
    name             = string
    pool             = string
    base_volume_path = string
    capacity         = number
  })
}
