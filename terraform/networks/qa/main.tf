module "network" {
  source = "../../modules/network"

  name                 = local.realm_name
  vpc_cidr             = local.vpc_cidr
  private_subnet_cidrs = local.private_subnet_cidrs
  public_subnet_cidrs  = local.public_subnet_cidrs
}
