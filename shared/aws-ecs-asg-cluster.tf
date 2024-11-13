# Look up the right AMI ID
# Lookup latest Base AMI releases: https://github.mheducation.com/base-amis/amazon-linux-ecs-optimized/releases
# module "al2_ecs_ami" {
#   source      = "git::ssh://git@github.mheducation.com/terraform/aws-base-ami.git?ref=3.2.1"
#   ami_os      = "al2"
#   ami_app     = "ecs"
#   ami_version = "1.7.0_6"
  # Default value is 64-bit Intel/AMD
#}
data "template_file" "user_data" {
  template = file("userdata.sh")
  vars = {
    Environment = module.aws_resource_tags.environment
    Application = module.aws_resource_tags.application
    Account     = module.aws_resource_tags.account

  }
}
# ECS Cluster with ASG, Launch Templates, and modern scaling practices like capacity providers.
# https://github.mheducation.com/terraform-incubator/aws-ecs-asg-cluster
module "aws_ecs_asg_cluster" {
  source = "git@github.mheducation.com:terraform/aws-ecs-asg-cluster.git?ref=6.0.1"


  # General configuration
  ami_id        = "ami-0fae88c1e6794aa17"
  instance_type = local.instance_type

  root_volume_size = 50

  # Cluster size
  cluster_desired_size = local.cluster_min_size # Let the service determine how many instances to run
  cluster_min_size     = local.cluster_min_size
  cluster_max_size     = local.cluster_max_size
  target_capacity      = local.target_capacity

  # Network/VPC configuration
  subnets = data.aws_subnets.private.ids
  security_groups = [
    aws_security_group.sep_nonprod.id,
    data.aws_security_group.FW_Manager_Default_SG.id,
    module.aws_ec2_alb_sg.launch_template_security_group.id
  ]
  tags                 = local.filtered_common_tags
  additional_user_data = data.template_file.user_data.rendered

}
