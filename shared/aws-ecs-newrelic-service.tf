# Sets up the NewRelic agent container as a daemon-mode ECS Task.
# https://github.mheducation.com/terraform-incubator/aws-ecs-newrelic-service
module "aws_ecs_newrelic_service" {
  source = "git@github.mheducation.com:terraform/aws-ecs-newrelic-service.git?ref=3.1.7"

  # Cluster
  ecs_cluster_arn = module.aws_ecs_asg_cluster.ecs_cluster.arn

  ps_key_license = "/global/infra/newrelic/prod"

  tags = local.filtered_common_tags
}
