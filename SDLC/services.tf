locals {
  # ALB Listener rule priority ranges from 1 to 50000. See https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticloadbalancingv2-listenerrule.html
  environment_priority = {
    dev  = 6000
    prod = 1000
  }
}

# Light Backend API
# module "service_backend_api" {
#   source = "./services/backend_api"

#   service_name = "backend_api"

#   host_header = sort([
#     local.backend_api_sdlc_fqdn, # long name such as sdlc.app.prod/nonprod.mheducation.com
#     ],
#   )

#   # priority    = 100 + local.environment_priority[local.environment]

#   # Common settings
#   alb_listener_arn          = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
#   aws_region                = var.aws_region
#   aws_account_id            = data.aws_caller_identity.current.account_id
#   capacity_provider_name    = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags               = local.filtered_common_tags_backend_api
#   ecs_cluster_arn           = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   vpc_id                    = data.aws_vpc.non-default.id
#   internal_subnet_ids       = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id = data.terraform_remote_state.shared.outputs.default_sg
#   alb_target_group_arn      = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
#   #image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
#   dark_enabled               = false
#   deploy_min_healthy_percent = 100
#   healthcheck_path           = "/"
# }


# Light Backend API
module "bnb_poc" {
  source = "./services/bnb_poc"

  service_name = "bnb_poc"

  host_header = sort([
    local.backend_api_sdlc_fqdn, # long name such as sdlc.app.prod/nonprod.mheducation.com
    ],
  )

  # priority    = 100 + local.environment_priority[local.environment]

  # Common settings
  alb_listener_arn          = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
  aws_region                = var.aws_region
  aws_account_id            = data.aws_caller_identity.current.account_id
  capacity_provider_name    = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
  common_tags               = local.filtered_common_tags_bnb_poc
  ecs_cluster_arn           = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
  vpc_id                    = data.aws_vpc.non-default.id
  internal_subnet_ids       = data.terraform_remote_state.shared.outputs.private_subnet_ids
  default_security_group_id = data.terraform_remote_state.shared.outputs.default_sg
  alb_target_group_arn      = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
  #image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
  dark_enabled               = false
  deploy_min_healthy_percent = 100
  healthcheck_path           = "/"
}

# Dark Backend API
# module "service_backend_api_dark" {
#   source = "./services/backend_api"

#   service_name = "backend_api"

#   host_header = sort([
#     local.backend_api_sdlc_fqdn_dark, # long name such as sdlc.app.prod/nonprod.mheducation.com
#     ],
#   )

#   # priority    = 100 + local.environment_priority[local.environment]

#   # Common settings
#   alb_listener_arn           = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
#   aws_region                 = var.aws_region
#   aws_account_id             = data.aws_caller_identity.current.account_id
#   capacity_provider_name     = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags                = local.filtered_common_tags_backend_api_dark
#   ecs_cluster_arn            = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   vpc_id              = data.aws_vpc.non-default.id
#   internal_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id  = data.terraform_remote_state.shared.outputs.default_sg
#   alb_target_group_arn       = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
#   image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
#   dark_enabled               = true
#   deploy_min_healthy_percent = 100
#   healthcheck_path           = "/"
# }



# # Light Frontend API
# module "service_frontend_api" {
#   source = "./services/frontend_api"

#   service_name = "frontend_api"

#   host_header = sort([
#     local.frontend_api_sdlc_fqdn, # long name such as sdlc.app.prod/nonprod.mheducation.com
#     ],
#   )

#   # priority    = 100 + local.environment_priority[local.environment]

#   # Common settings
#   alb_listener_arn          = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
#   aws_region                = var.aws_region
#   aws_account_id            = data.aws_caller_identity.current.account_id
#   capacity_provider_name    = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags               = local.filtered_common_tags_frontend_api
#   ecs_cluster_arn           = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   oidc_role_arn             = data.terraform_remote_state.init.outputs.infra_iam_role_arn
#   sqs_arn                   = module.sep_event.aws_sqs_sep_eventing_arn
#   vpc_id                    = data.aws_vpc.non-default.id
#   internal_subnet_ids       = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id = data.terraform_remote_state.shared.outputs.default_sg
#   alb_target_group_arn      = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
#   #image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
#   dark_enabled               = false
#   deploy_min_healthy_percent = 100
#   healthcheck_path           = "/"
# }

# # Dark Frontend API
# # module "service_frontend_api_dark" {
# #   source = "./services/frontend_api"

# #   service_name = "frontend_api"

# #   host_header = sort([
# #     local.frontend_api_sdlc_fqdn_dark, # long name such as sdlc.app.prod/nonprod.mheducation.com
# #     ],
# #   )

# #   # priority    = 100 + local.environment_priority[local.environment]

# #   # Common settings
# #   alb_listener_arn           = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
# #   aws_region                 = var.aws_region
# #   aws_account_id             = data.aws_caller_identity.current.account_id
# #   capacity_provider_name     = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
# #   common_tags                = local.filtered_common_tags_frontend_api_dark
# #   ecs_cluster_arn            = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
# #   vpc_id                     = data.aws_vpc.non-default.id
# #   internal_subnet_ids        = data.terraform_remote_state.shared.outputs.private_subnet_ids
# #   default_security_group_id  = data.terraform_remote_state.shared.outputs.default_sg
# #   alb_target_group_arn       = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
# #   image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
# #   dark_enabled               = true
# #   deploy_min_healthy_percent = 100
# #   healthcheck_path           ="/"
# # }


# # Light Backend APP
# module "service_backend_app" {
#   source = "./services/backend_app"

#   service_name = "backend_app"

#   host_header = sort([
#     local.backend_app_sdlc_fqdn, # long name such as sdlc.app.prod/nonprod.mheducation.com
#     ],
#   )

#   # priority    = 100 + local.environment_priority[local.environment]

#   # Common settings
#   alb_listener_arn          = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
#   aws_region                = var.aws_region
#   aws_account_id            = data.aws_caller_identity.current.account_id
#   capacity_provider_name    = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags               = local.filtered_common_tags_backend_app
#   ecs_cluster_arn           = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   vpc_id                    = data.aws_vpc.non-default.id
#   internal_subnet_ids       = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id = data.terraform_remote_state.shared.outputs.default_sg
#   alb_target_group_arn      = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
#   #image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
#   dark_enabled               = false
#   deploy_min_healthy_percent = 100
#   healthcheck_path           = "/api/healthcheck"
# }

# # Dark Backend APP
# # module "service_backend_app_dark" {
# #   source = "./services/backend_app"

# #   service_name = "backend_app"

# #   host_header = sort([
# #     local.backend_app_sdlc_fqdn_dark, # long name such as sdlc.app.prod/nonprod.mheducation.com
# #     ],
# #   )

# #   # priority    = 100 + local.environment_priority[local.environment]

# #   # Common settings
# #   alb_listener_arn           = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
# #   aws_region                 = var.aws_region
# #   aws_account_id             = data.aws_caller_identity.current.account_id
# #   capacity_provider_name     = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
# #   common_tags                = local.filtered_common_tags_backend_app_dark
# #   ecs_cluster_arn            = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
# #   vpc_id                     = data.aws_vpc.non-default.id
# #   internal_subnet_ids        = data.terraform_remote_state.shared.outputs.private_subnet_ids
# #   default_security_group_id  = data.terraform_remote_state.shared.outputs.default_sg
# #   alb_target_group_arn       = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
# #   image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
# #   dark_enabled               = true
# #   deploy_min_healthy_percent = 100
# #   healthcheck_path           = "/api/healthcheck"
# # }


# # Light Frontend APP
# module "service_frontend_app" {
#   source = "./services/frontend_app"

#   service_name = "frontend_app"

#   host_header = sort([
#     local.frontend_app_sdlc_fqdn, # long name such as sdlc.app.prod/nonprod.mheducation.com
#     ],
#   )

#   # priority    = 100 + local.environment_priority[local.environment]

#   # Common settings
#   alb_listener_arn          = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
#   aws_region                = var.aws_region
#   aws_account_id            = data.aws_caller_identity.current.account_id
#   capacity_provider_name    = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags               = local.filtered_common_tags_frontend_app
#   ecs_cluster_arn           = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   vpc_id                    = data.aws_vpc.non-default.id
#   internal_subnet_ids       = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id = data.terraform_remote_state.shared.outputs.default_sg
#   alb_target_group_arn      = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
#   #image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
#   dark_enabled               = false
#   deploy_min_healthy_percent = 100
#   healthcheck_path           = "/api/healthcheck"
# }

# # Dark Frontend APP
# # module "service_frontend_app_dark" {
# #   source = "./services/frontend_app"

# #   service_name = "frontend_app"

# #   host_header = sort([
# #     local.frontend_app_sdlc_fqdn_dark, # long name such as sdlc.app.prod/nonprod.mheducation.com
# #     ],
# #   )

# #   # priority    = 100 + local.environment_priority[local.environment]

# #   # Common settings
# #   alb_listener_arn           = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
# #   aws_region                 = var.aws_region
# #   aws_account_id             = data.aws_caller_identity.current.account_id
# #   capacity_provider_name     = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
# #   common_tags                = local.filtered_common_tags_frontend_app_dark
# #   ecs_cluster_arn            = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
# #   vpc_id                     = data.aws_vpc.non-default.id
# #   internal_subnet_ids        = data.terraform_remote_state.shared.outputs.private_subnet_ids
# #   default_security_group_id  = data.terraform_remote_state.shared.outputs.default_sg
# #   alb_target_group_arn       = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
# #   image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
# #   dark_enabled               = true
# #   deploy_min_healthy_percent = 100
# #   healthcheck_path           = "/api/healthcheck"
# # }

# # Log Stash
# module "service_log_stash" {
#   source = "./services/log_stash"

#   service_name = "log_stash"

#   # host_header = sort([
#   #   local.frontend_app_sdlc_fqdn, # long name such as sdlc.app.prod/nonprod.mheducation.com
#   #   ],
#   # )

#   # Common settings
#   #alb_listener_arn          = data.terraform_remote_state.shared.outputs.aws-alb-http.listener.arn
#   aws_region                = var.aws_region
#   aws_account_id            = data.aws_caller_identity.current.account_id
#   capacity_provider_name    = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags               = local.filtered_common_tags_log_stash
#   ecs_cluster_arn           = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   vpc_id                    = data.aws_vpc.non-default.id
#   internal_subnet_ids       = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id = data.terraform_remote_state.shared.outputs.default_sg
#   #alb_target_group_arn      = data.terraform_remote_state.shared.outputs.aws_alb_http_target_group
#   #image_repository           = data.terraform_remote_state.shared.outputs.aws_ecr_repository_api
#   dark_enabled               = false
#   deploy_min_healthy_percent = 100
# }

# # Data Sync
# module "service_data_sync" {
#   source = "./services/data_sync"

#   service_name = "data_sync"

#   # Common settings
#   aws_region                 = var.aws_region
#   aws_account_id             = data.aws_caller_identity.current.account_id
#   capacity_provider_name     = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.cluster_capacity_provider.name
#   common_tags                = local.filtered_common_tags_data_sync
#   ecs_cluster_arn            = data.terraform_remote_state.shared.outputs.aws-ecs-asg-cluster.ecs_cluster.arn
#   vpc_id                     = data.aws_vpc.non-default.id
#   internal_subnet_ids        = data.terraform_remote_state.shared.outputs.private_subnet_ids
#   default_security_group_id  = data.terraform_remote_state.shared.outputs.default_sg
#   dark_enabled               = false
#   deploy_min_healthy_percent = 100
# }

# # SEP 3rd Party events message to SQS from an ECS task
# module "sep_event" {
#   source      = "./services/sqs"
#   common_tags = module.aws_resource_tags_sqs.common_tags
# }

# module "sep_task_def_secrets" {
#   source = "./services/secret_manager"
#   tags   = module.aws_resource_tags.common_tags
# }

# data "aws_secretsmanager_secret_version" "maia_secrets" {
#   secret_id = module.sep_task_def_secrets.sep_secrets.id
# }
# output "sep_secret" {
#   value = module.sep_task_def_secrets.sep_secrets.arn
# }
