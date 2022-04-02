variable "ansible_ssh_user" {}
variable "ansible_ssh_private_key_path" {}
variable "vnc_default_password" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket  = "devops-team-tfstate"
    key     = "devops/aws/us-east-1/s3/devopskats/common/network/${local.env}"
    region  = "${local.region}"
    profile = "awsdevopskats"
  }
}

module "jumpbox" {
  source = "../../modules/jumpbox"

  name                         = "${local.realm_name}-jumpbox"
  vpc_id                       = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id                    = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  ansible_ssh_user             = var.ansible_ssh_user
  ansible_ssh_private_key_path = var.ansible_ssh_private_key_path
  app_env                      = local.env
  vnc_default_password         = var.vnc_default_password
}
