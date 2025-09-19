#eks-vps-cluster/variables.tf
variable "name" {
    description = "The name of homework-5-6 the EKS cluster"
    type        = string
    default     = "homework-5-6"
}

variable "cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "azs" {
    description = "A list of availability zones in the region"
    type        = list(string)
    default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  
}

variable "private_subnets" {
    description = "A list of private subnets in the VPC"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  
}

variable "public_subnets" {
    description = "A list of public subnets in the VPC"
    type        = list(string)
    default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
}

variable "tags" {
    description = "A map of tags to add to all resources"
    type        = map(string)
    default     = {
        "Environment" = "dev"
        "Project"     = "homework-5-6"
    }
  
}

variable "cluster_name" {
    description = "The name of homework-5-6the EKS cluster"
    type        = string
    default     = "homework-5-6"
  
}

variable "cluster_version" {
    description = "The Kubernetes version for the EKS cluster"
    type        = string
    default     = "1.31"
  
}

variable "aws_region" {
    description = "The AWS region to deploy the EKS cluster"
    type        = string
    default     = "eu-west-1"
  
}


variable "provider_profile" {
    description = "The AWS provider profile"
    type        = string
    default     = "davydovpetro-homework-5-6"
  
}





