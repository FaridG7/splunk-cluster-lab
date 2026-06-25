variable "name" {
  type = string
}
variable "base_image_path" {
  description = "Path to the base image file (accepts url too)"
  type        = string
}

variable "capacity" {
  description = "The capacity of the root volume in gigabytes"
  type        = number
  default     = 40
}
