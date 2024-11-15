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
    prod    = "t2.micro"
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

  userdata = <<-USERDATA
  #! /bin/bash
    cat << EOF >> /etc/ecs/ecs.config
    ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1m
    ECS_IMAGE_CLEANUP_INTERVAL=10m
    ECS_IMAGE_MINIMUM_CLEANUP_AGE=1m
    ECS_CONTAINER_STOP_TIMEOUT=5s
    ECS_IMAGE_PULL_BEHAVIOR=once
    export DOCKER_CONTENT_TRUST=0
    EOF
    AZ=$(wget http://169.254.169.254/latest/meta-data/placement/availability-zone -qO -)
    Instance=$(wget http://169.254.169.254/latest/meta-data/local-ipv4 -qO - | awk -F . '{ print $3"-"$4}')
    Instanceip=$(wget http://169.254.169.254/latest/meta-data/local-ipv4 -qO -)
    instance_id=$(wget http://169.254.169.254/latest/meta-data/instance-id -qO -)
    USER_DATA=$(wget http://169.254.169.254/latest/user-data -qO -)
    REGION=$(wget http://169.254.169.254/latest/meta-data/placement/region -qO -)
    #construct Hostname
    Hostname=$AZ-$Application-$Environment-$Instance
    echo "$Hostname" > /etc/hostname
    hostname "$Hostname"
    echo HOSTNAME="$Hostname"/ >> /etc/sysconfig/network
    sed -i "s/HOSTNAME=.*$/HOSTNAME=$Hostname/" /etc/sysconfig/network
    echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
    echo "$Instanceip  $Hostname" >> /etc/hosts

    #Instance Tagging
    aws ec2 create-tags --resources "$instance_id" --tags \
    Key=Name,Value="$AZ"-"$Application"-"$Environment"-"$Instance" --region "$REGION"
    aws ec2 create-tags --resources "$instance_id" --tags \
    Key=Application,Value="$Application" --region "$REGION"
    aws ec2 create-tags --resources "$instance_id" --tags \
    Key=Function,Value="$Function" --region "$REGION"
    aws ec2 create-tags --resources "$instance_id" --tags \
    Key=Environment,Value="$Environment" --region "$REGION"
    aws ec2 create-tags --resources "$instance_id" --tags \
    Key=Platform,Value="$Platform" --region "$REGION"
    echo "Userdata Completed Successfully"
  USERDATA

  cluster_name = "${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}"
}

