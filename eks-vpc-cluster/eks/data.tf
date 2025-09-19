#eks-vps-cluster/eks/data.tf
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "MLOps-CI-CD-homework-5-6"
    key     = "vpc/terraform.tfstate"
    region  = "eu-west-1"
    profile = "davydovpetro-homework-5-6" ## ваша назва профілю
  }
}

