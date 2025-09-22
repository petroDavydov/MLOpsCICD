#eks-vpc-cluster/backend.tf
terraform {
    backend "s3" {
        bucket         = "davydovpetro-homework-7"
        key            = "root/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
        dynamodb_table = "davydovpetro-homework-7-terraform-locks"
        profile = "davydovpetro-homework-7"
    }

}