#eks-vps-cluster/eks/variables.tf

variable "cluster_name" {
  default = "homework-7"
}


variable "cluster_version" {
  default = "1.31"
}


variable "aws_region" {
  default     = "us-east-1"
  description = "The most profitable region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}