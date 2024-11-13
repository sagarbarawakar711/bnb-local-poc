# API PARAMS

# WORKER & API SEPARATE PARAMS
# resource "aws_ssm_parameter" "log_level" {
#   name  = "/${local.application}/${local.environment}/${local.function}/LOG_LEVEL"
#   type  = "String"
#   value = var.log_level
#   tags  = var.tags
#   lifecycle {
#     ignore_changes = [
#       value,
#     ]
#   }
# }

resource "aws_secretsmanager_secret" "sep_secrets" {
  name = "/${local.application}/${local.environment}/task_def"
  tags = var.tags
  # lifecycle {
  #   ignore_changes = [value]
  # }
}

output "sep_secrets" {
  value = aws_secretsmanager_secret.sep_secrets
}
