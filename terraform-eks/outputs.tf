output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks_cluster.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "eks_cluster_ca_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks_cluster.cluster_ca_data
}
