#eks-vpc-cluster/backend.tf
terraform {
    backend "s3" {
        bucket         = "MLOps-CI-CD-homework-5-6"
        key            = "root/terraform.tfstate"
        region         = "eu-west-1"
        encrypt        = true
        dynamodb_table = "my-terraform-lock-table"
        profile = "davydovpetro-homework-5-6"
    }

}