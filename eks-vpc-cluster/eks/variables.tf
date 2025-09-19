#eks-vps-cluster/eks/variables.tf

variable "cluster_name" {
  default = "homework-5-6"
}


variable "cluster_version" {
  default = "1.31"
}


variable "aws_region" {
  default     = "eu-west-1"
  description = "The most profitable region"
}