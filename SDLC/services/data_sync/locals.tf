locals {
  container_image = "${local.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.common_tags.Account}-sep-${local.sdlc_env}-api:${local.image_tag}"
  image_tag = var.common_tags.Environment == "dev" ? "${var.common_tags.Account}-sep-${var.common_tags.Environment}-data-sync-72213124fed28c44f6a2c1ec40111e7e23834a86" : "data-sync-72213124fed28c44f6a2c1ec40111e7e23834a86"
  #container_image = "repo.mhe.io/docker/testcontainers/helloworld:latest"
  #container_port = 8000
  container_port = 8080

  account_type    = terraform.workspace == "prod" ? "prod" : "nonprod"
  iam_path_prefix = join("/", ["", var.common_tags.Account, var.common_tags.Application, ""])
  # contentsearch_sdlc_fqdn = "blue-${local.environment}.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"

  service_full_name                   = join("-", [var.common_tags.Account, var.common_tags.Application, var.common_tags.Environment, "data-sync"])
  service_full_name_without_account   = join("-", [var.common_tags.Application, var.common_tags.Environment, "data-sync"])
  task_min_count                      = var.dark_enabled ? 0 : var.task_min_count_config_map[terraform.workspace]
  task_max_count                      = var.dark_enabled ? 1 : var.task_max_count_config_map[terraform.workspace]
  task_cpu_target_percent             = var.dark_enabled ? 100 : var.task_cpu_target_percent_config_map[terraform.workspace]
  task_memory_target_percent          = var.dark_enabled ? 100 : var.task_memory_target_percent_config_map[terraform.workspace]
  task_healthcheck_timeout_in_seconds = var.task_healthcheck_timeout_in_seconds_config_map[terraform.workspace]
  deregistration_delay_seconds        = var.deregistration_delay_seconds_config_map[terraform.workspace]
  start_delay_seconds                 = var.start_delay_seconds_config_map[terraform.workspace]
  secret_manager_arn_id               = var.secret_manager_arn_id[terraform.workspace]

  tass_grant_type = "client_credentials"
  tass_scope      = "auth"
  application     = "sep"
  #function    = var.common_tags["Function"]
  ecs_resource_id = "service/${split("/", data.aws_arn.ecs_cluster_arn.resource)[1]}/${aws_ecs_service.data_sync_service.name}"
  sdlc_env        = var.common_tags.Environment == "prod" ? "prod" : "nonprod"
  aws_account_id  = data.aws_caller_identity.self.account_id
}

data "aws_arn" "ecs_cluster_arn" {
  arn = var.ecs_cluster_arn
}
data "aws_caller_identity" "self" {}
