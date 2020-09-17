module "vpc" {
  cidr           = var.vpc["cidr"]
  name           = var.vpc["name"]
  azs            = split(",", var.vpc["azs"])
  public_subnets = split(",", var.vpc["public_subnets"])
}
