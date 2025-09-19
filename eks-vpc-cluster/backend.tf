#eks-vpc-cluster/backend.tf
terraform {
    backend "s3" {
        bucket         = "davydovpetro-homework-5-6-tfstate"
        key            = "root/terraform.tfstate"
        region         = "eu-west-1"
        encrypt        = true
        dynamodb_table = "davydovpetro-homework-5-6-locks"
        profile = "davydovpetro-homework-5-6"
    }

}