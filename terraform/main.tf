module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr           = var.vpc["cidr"]
  name           = var.vpc["name"]
  azs            = split(",", var.vpc["azs"])
  public_subnets = split(",", var.vpc["public_subnets"])
}
