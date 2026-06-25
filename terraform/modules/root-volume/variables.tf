variable "spec" {
  description = "Specification for the root volume"
  type = object({
    name            = string
    pool            = string
    base_image_path = string
    capacity        = number
  })
}
