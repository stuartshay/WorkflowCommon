variable "name" {
  description = "The network name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "igw_routes" {
  description = "The routes via internet gateway"
  type        = list(any)
  default     = []
}

variable "nat_gw_routes" {
  description = "The routes via NAT gateway"
  type        = list(any)
  default     = []
}

variable "subnet_ids" {
  description = "The subnet IDs"
  type        = list(string)
}
