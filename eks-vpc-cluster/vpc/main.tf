#eks-vps-cluster/vpc/main.tf
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = var.name
  cidr = var.cidr

  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets =  var.public_subnets 

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = var.tags
}

