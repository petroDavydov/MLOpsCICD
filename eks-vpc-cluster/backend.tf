#eks-vpc-cluster/backend.tf
terraform {
    backend "s3" {
        bucket         = "davydovpetro-homework-8-9-tfstate"
        key            = "root/terraform.tfstate"
        region         = "eu-west-1"
        encrypt        = true
        dynamodb_table = "davydovpetro-homework-8-9-locks"
        profile        = "davydovpetro-homework-8-9"
    }

}