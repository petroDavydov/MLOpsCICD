# #eks-vps-cluster/vpc/backend.tf
# terraform {
#   backend "s3" {
#     bucket         = "davydovpetro-homework-7-tfstate"
#     key            = "vpc/terraform.tfstate"
#     region         = "eu-west-1"
#     encrypt        = true
#     profile        = "davydovpetro-homework-7"
#     dynamodb_table = "davydovpetro-homework-7-locks"
#   }
# }