#eks-vps-cluster/main.tf
module "vpc" {
  source = "./vpc"

  name = var.name
  cidr = var.cidr
  azs  = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags = var.tags

  
  
}

module "eks" {
  source = "./eks"

    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    aws_region = var.aws_region  
}