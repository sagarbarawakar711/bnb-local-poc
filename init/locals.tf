locals {
  role_prefix_name       = join("-", [module.aws_resource_tags.account, local.filtered_common_tags.Application, local.account_type])
  role_infra_prefix_name = "${local.role_prefix_name}-infra"

  account_type         = local.environment == "prod" ? "prod" : "nonprod"
  aws_account_id       = data.aws_caller_identity.current.account_id
  environment          = terraform.workspace
  iam_name_prefix      = join("-", [module.aws_resource_tags.account, local.filtered_common_tags.Application])
  iam_path_prefix      = join("/", ["", module.aws_resource_tags.account, local.filtered_common_tags.Application, ""])
  mhe_account_id       = substr(data.aws_vpc.non-default.tags["Name"], 0, 3)
  resource_name_prefix = join("-", compact([module.aws_resource_tags.account, local.filtered_common_tags.Application, lookup(local.filtered_common_tags, "Function", ""), local.filtered_common_tags.Environment]))


  infra_custom_managed_policies = [
    "${local.iam_path_prefix}${aws_iam_policy.infra_custom_managed_policy_misc.name}",
    "${local.iam_path_prefix}${aws_iam_policy.infra_custom_managed_policy_iam.name}",
    "${local.iam_path_prefix}${aws_iam_policy.infra_custom_managed_policy_waf.name}",
    "/ec2_operator",
    "/iam_operator",
    "/lambda_admin"
  ]
}
