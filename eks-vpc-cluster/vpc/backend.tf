# #eks-vps-cluster/vpc/backend.tf
# terraform {
#   backend "s3" {
#     bucket         = "davydovpetro-homework-8-9-tfstate"
#     key            = "vpc/terraform.tfstate"
#     region         = "eu-west-1"
#     encrypt        = true
#     profile        = "davydovpetro-homework-8-9"
#     dynamodb_table = "davydovpetro-homework-8-9-locks"
#   }
# }