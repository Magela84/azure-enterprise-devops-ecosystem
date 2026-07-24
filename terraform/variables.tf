variable "environment" {
  type        = string
  description = "The target deployment stage (dev, staging, prod)"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The IP address range for the Virtual Network"
}

variable "subnet_address_prefix" {
  type        = list(string)
  description = "The IP range segment for the application subnet"
}
