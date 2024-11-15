variable "common_tags" {
  description = "Output from the aws-resources-tags module"
  type        = map(any)
}

variable "service_name" {
  description = "Service name."
  type        = string
}

variable "capacity_provider_name" {
  description = "ARN for the capacity provider, created with the cluster in shared layer."
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS cluster."
  type        = string
}

variable "oidc_role_arn" {
  description = "ARN of the OIDC IAM Role."
  type        = string
}
variable "sqs_arn" {
  description = "ARN of the SQS."
  type        = string
}
# variable "image_repository" {
#   description = "Image repository URL"
#   type        = string
# }

variable "alb_listener_arn" {
  description = "ARN of the ALB listener."
  type        = string
}

variable "alb_target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "healthcheck_path" {
  description = "Path at which the healthcheck endpoint is served."
  type        = string
}

variable "aws_region" {
  description = "AWS region to manage resources in."
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID."
  type        = string
}

variable "host_header" {
  description = "Host header for using in ALB listener rule."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id used to attach the target_group to the vpc."
  type        = string
}

variable "internal_subnet_ids" {
  description = "IDs of internal subnets."
  type        = list(string)
  default     = []
}

variable "default_security_group_id" {
  description = "ID of default SG."
  type        = string
  default     = ""
}

variable "sqs_queue_url" {
  type    = string
  default = ""
}

variable "sqs_queue_name" {
  type    = string
  default = ""
}

variable "dark_enabled" {
  type    = bool
  default = false
}

variable "deploy_min_healthy_percent" {
  type    = number
  default = 75
}
variable "image_commit_hash" {
  description = "Commit hash for docker image tag."
  type        = string
  default     = "commit_2594e6f4fd4140c1c16d2b21a025689bc0c2edac"
}
variable "DEPLOYMENT_ENVIRONMENT" {
  description = "Set deployment environment values based on the dark and light service for indexing in OpenSearch."
  type        = string
  default     = ""
}
