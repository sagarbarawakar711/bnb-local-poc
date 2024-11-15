# # https://github.mheducation.com/terraform/aws-ecs-newrelic-logging
# module "aws_ecs_newrelic_logging" {
#   source = "git@github.mheducation.com:terraform/aws-ecs-newrelic-logging.git?ref=1.5.0"

#   service_container_name = local.service_full_name
#   service_container_newrelic_logs = {
#     enabled        = true
#     ps_key_license = local.newrelic_license_key_ps_path[terraform.workspace]
#   }
#   service_container_awslogs = {
#     enabled           = true
#     log_group_name    = aws_cloudwatch_log_group.default.name
#     log_stream_prefix = "service"
#     log_key           = "message"
#   }

#   log_router_container_name = "${local.service_full_name}-log-router"
#   log_router_container_awslogs = {
#     enabled           = true
#     log_group_name    = aws_cloudwatch_log_group.default.name
#     log_stream_prefix = "fluentbit"
#   }
#   log_router_cpu_reservation    = 60
#   log_router_memory_reservation = 60

#   fluentbit_enable_config_logging = true
#   fluentbit_parsers_config        = <<-EOT
#     [PARSER]
#       Name application_log
#       Format json
#     EOT
#   fluentbit_extra_config          = <<-EOT
#     [FILTER]
#       Name modify
#       Match *
#       Add hostname $${HOSTNAME}
#       Add environment ${terraform.workspace}
#       Add platform ${var.common_tags.Platform}
#       Add service_name ${local.service_full_name}
#     ${""}
#     [FILTER]
#       Name parser
#       Match *
#       Parser application_log
#       Key_Name log
#       Reserve_Data On
#     ${""}
#     [FILTER]
#       Name modify
#       Match *
#       Rename log message
#       Add log-type application
#     [FILTER]
#       Name          rewrite_tag
#       Match         ${local.service_full_name}-firelens-*
#       Rule          $message ^([\.a-z0-9-]+.com.*)$ accesstag false
#       Emitter_Name  re_emitted
#     [FILTER]
#       Name modify
#       Match accesstag
#       Set log-type access
#     [OUTPUT]
#       Name        newrelic
#       Match       accesstag
#       licenseKey  $${NEWRELIC_LICENSE_KEY}
#     EOT
# }

# locals {
#   newrelic_license_key_ps_path = {
#     nonprod = "/global/infra/newrelic/default"
#     dev     = "/global/infra/newrelic/default"
#     prod    = "/global/infra/newrelic/default"
#   }
# }
