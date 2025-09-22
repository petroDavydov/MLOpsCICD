# eks-vpc-cluster/argocd/outputs.tf

output "argocd_namespace" {
  value       = var.argocd_namespace
  description = "Namespace where ArgoCD is deployed"
}


