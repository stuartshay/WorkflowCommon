variable "name" {
  description = "The jumpbox name"
  type        = string
}

variable "vpc_id" {
  description = "A VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "A VPC subnets"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.small"
}

variable "ami_id" {
  description = "The EC2 AMI ID"
  type        = string
  default     = "ami-04505e74c0741db8d"
}

variable "key_name" {
  description = "The EC2 instance key ssh name"
  type        = string
  default     = "culiops"
}

variable "root_volume_size" {
  description = "The EC2 instance root volume size"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Add more tags"
  type        = map(string)
  default     = {}
}

variable "ansible_ssh_user" {
  description = "The SSH user to access server"
  type        = string
}

variable "ansible_ssh_private_key_path" {
  description = "The SSH private key path to access server"
  type        = string
}

variable "app_env" {
  description = "The ENV"
  type        = string
  default     = "develop"
}

variable "vnc_default_password" {
  description = "The VNC password"
  type        = string
}
