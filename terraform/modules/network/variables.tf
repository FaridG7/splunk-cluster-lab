variable "spec" {
  description = "Specification for the network"
  type = object({
    name         = string
    cidr_address = string
  })
}
