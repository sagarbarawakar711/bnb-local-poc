#
# Modules
#

output "aws-alb-http" {
  description = "Output of the `aws_alb_http` module."
  value       = module.aws_alb_http
  sensitive   = true
}


output "aws-ecs-asg-cluster" {
  description = "Output of the `aws_ecs_asg_cluster` module."
  value       = module.aws_ecs_asg_cluster
  sensitive   = false
}
output "aws_ecs_asg_cluster_iam_role" {
  description = "Output of the EC2 role name."
  value       = module.aws_ecs_asg_cluster.iam_role.name
  sensitive   = false
}

output "aws_alb_http_target_group" {
  description = "ARN of the target group."
  value       = module.aws_alb_http.target_group.arn
  sensitive   = false
}

output "aws-dns-public-zone" {
  description = "Public zone object for the main Route 53 zone."
  # mimicking output of aws-dns-public-zone module interface
  sensitive = false
  value = {
    hosted_zone = merge({ "name_trimmed" = trimsuffix(aws_route53_zone.main.name, ".") }, aws_route53_zone.main)
  }
}

output "private_subnet_ids" {
  value = [for s in data.aws_subnet.private : s.cidr_block]
}
output "public_subnet_ids" {
  value = [for s in data.aws_subnet.public : s.cidr_block]
}

output "default_sg" {
  value = data.aws_security_group.FW_Manager_Default_SG.id
}
