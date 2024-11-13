# locals {
#   mhe_account_id  = substr(data.aws_vpc.non-default.tags["Name"], 0, 3)
#   resource_prefix = join("-", [module.aws_resource_tags.account, module.aws_resource_tags.application, module.aws_resource_tags.environment])


#   # For resources not tight to infrastructure SDLC
#   aws_account_id  = data.aws_caller_identity.self.account_id
#   account_type    = local.environment == "prod" ? "prod" : "nonprod"
#   turbot_account  = var.turbot_account_config_map[local.environment]
#   environment     = terraform.workspace
#   account_id      = data.aws_caller_identity.self.account_id
#   iam_path_prefix = join("/", ["", module.aws_resource_tags.account, local.filtered_common_tags.Application, ""])
#   name_prefix     = join("-", compact([module.aws_resource_tags.account, local.filtered_common_tags.Application, lookup(local.filtered_common_tags, "Function", ""), local.filtered_common_tags.Environment]))

# }
