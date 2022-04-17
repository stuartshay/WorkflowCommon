locals {
  name       = "navigatorglass"
  env        = "qa"
  region     = "us-east-1"
  realm_name = "${local.name}-${local.env}"

  tags = {
    application = local.name
    env         = local.env
    owner       = "devops"
  }

  vpc_cidr = "10.0.0.0/16"

  private_subnet_cidrs = {
    a = "10.2.0.0/20"
    b = "10.2.16.0/20"
    c = "10.2.32.0/20"
  }

  public_subnet_cidrs = {
    a = "10.2.64.0/20"
    b = "10.2.80.0/20"
    c = "10.2.96.0/20"
  }
}
