variable "cluster_min_size_config_map" {
  default = {
    nonprod = 2
    prod    = 0
  }
  description = "Minimum number of EC2 instances to keep running regardless of auto scaling"
  type        = map(number)
}

variable "cluster_max_size_config_map" {
  default = {
    nonprod = 3
    prod    = 0
  }
  description = "Maximum number of EC2 instances to keep running regardless of auto scaling"
  type        = map(number)
}

variable "instance_type_config_map" {
  default = {
    nonprod = "t2.micro"
    prod    = "m5a.large"
  }
  description = "The EC2 instance type to run in the ECS cluster. See https://aws.amazon.com/ec2/pricing/on-demand/"
  type        = map(string)
}

variable "target_capacity" {
  default = {
    nonprod = 100
    prod    = 90
  }
  type = map(number)
}

variable "inline_policy" {
  default = "unused"
}

locals {
  cluster_min_size = var.cluster_min_size_config_map[terraform.workspace]
  cluster_max_size = var.cluster_max_size_config_map[terraform.workspace]
  target_capacity  = var.target_capacity[terraform.workspace]
  instance_type    = var.instance_type_config_map[terraform.workspace]
}
