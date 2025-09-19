#eks-vps-cluster/eks/main.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"


  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version


  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets


  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true


  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }


  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
    
  }


  eks_managed_node_groups = {
    cpu-nodes = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }

    gpu-nodes = {
      instance_types = ["g4dn.xlarge"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      labels = {
        workload ="gpu"
      }

      taints = [
        {
        key = "gpu-added-group"
        value = "true"
        effect = "NoSchedule"
      }
   ]
  }
}




  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}