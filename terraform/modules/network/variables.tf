variable "name" {
  type        = string
  description = "The network name"
}

variable "vpc_cidr" {
  description = "The VPC CIDR"
  type        = string
  default     = "192.168.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "Private subnets for networks"
  type        = map(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnets for networks"
  type        = map(string)
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

