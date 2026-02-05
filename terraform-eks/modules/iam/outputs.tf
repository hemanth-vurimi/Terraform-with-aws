output "custer-role-arn" {
  description = "The ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster_role.arn
  
}

output "nodegroup-role-arn" {
  description = "The ARN of the EKS nodegroup IAM role"
  value       = aws_iam_role.eks_nodegroup_role.arn
}

output "cluster-role-name" {
    description = "The name of the EKS cluster IAM role"
    value       = aws_iam_role.eks_cluster_role.name
  
}

output "nodegroup-role-name" {
    description = "The name of the EKS nodegroup IAM role"
    value       = aws_iam_role.eks_nodegroup_role.name
  
}

output "eks_nodegroup_role_arn" {
  value = aws_iam_role.eks_nodegroup_role.arn
}
output "eks_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}