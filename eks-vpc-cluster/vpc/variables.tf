#eks-vps-cluster/vpc/variables.tf
variable "name" {
    type= string
    default = "homework-5-6"
}

variable "cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "azs" {
    type = list(string)
    default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type = list(string)
  default = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]
}

variable "tags" {
    type = map(string)
    default = {
      "Terraform" = "true"
      Environment = "dev"
    }
}





