locals {
  account_type          = terraform.workspace == "prod" ? "prod" : "nonprod"
  environment           = terraform.workspace
  mhe_account_id        = substr(data.aws_vpc.non-default.tags["Name"], 0, 3)
  iam_path_prefix       = join("/", ["", module.aws_resource_tags.account, local.filtered_common_tags.Application, ""])
  name_prefix           = "${module.aws_resource_tags.account}_${local.filtered_common_tags.Application}_${local.environment}"
  s3_logs_bucket_prefix = join("-", [module.aws_resource_tags.account, module.aws_resource_tags.application, local.account_type])


  domain_name = local.account_type == "prod" ? "prod.uiplonline.com" : "sep.nonprod.mheducation.com"

  sep_cf_cert_hostname = local.account_type == "prod" ? "static.${local.domain_name}" : "${local.environment}-static.sep.nonprod.mheducation.com"

  backend_api_sdlc_fqdn = local.account_type == "prod" ? "api.admin.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}" : "${local.environment}-api-admin.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"
  #backend_api_sdlc_fqdn_dark = "dark-${local.environment}-api.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"

  frontend_api_sdlc_fqdn = local.account_type == "prod" ? "api.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}" : "${local.environment}-api.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"
  #frontend_api_sdlc_fqdn_dark = "dark-${local.environment}-api.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"

  backend_app_sdlc_fqdn = local.account_type == "prod" ? "admin.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}" : "${local.environment}-admin.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"
  #backend_app_sdlc_fqdn_dark = "dark-${local.environment}-admin.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"

  frontend_app_sdlc_fqdn = local.account_type == "prod" ? data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed : "${local.environment}.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"
  #frontend_app_sdlc_fqdn_dark = "dark-${local.environment}.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"


  sep_sdlc_fqdn_sqs = "${local.environment}-sqs.${data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.name_trimmed}"




  ### Common Tags for the services
  filtered_common_tags = {
    for key, value in module.aws_resource_tags.common_tags : key => value if value != ""
  }
  filtered_common_tags_backend_api = {
    for key, value in module.aws_resource_tags_backend_api.common_tags : key => value if value != ""
  }
  filtered_common_tags_bnb_poc = {
    for key, value in module.aws_resource_tags_bnb_poc.common_tags : key => value if value != ""
  }
  filtered_common_tags_backend_api_dark = {
    for key, value in module.aws_resource_tags_backend_api_dark.common_tags : key => value if value != ""
  }
  filtered_common_tags_frontend_api = {
    for key, value in module.aws_resource_tags_frontend_api.common_tags : key => value if value != ""
  }
  filtered_common_tags_frontend_api_dark = {
    for key, value in module.aws_resource_tags_frontend_api_dark.common_tags : key => value if value != ""
  }

  filtered_common_tags_backend_app = {
    for key, value in module.aws_resource_tags_backend_app.common_tags : key => value if value != ""
  }
  filtered_common_tags_backend_app_dark = {
    for key, value in module.aws_resource_tags_backend_app_dark.common_tags : key => value if value != ""
  }
  filtered_common_tags_frontend_app = {
    for key, value in module.aws_resource_tags_frontend_app.common_tags : key => value if value != ""
  }
  filtered_common_tags_frontend_app_dark = {
    for key, value in module.aws_resource_tags_frontend_app_dark.common_tags : key => value if value != ""
  }
  filtered_common_tags_log_stash = {
    for key, value in module.aws_resource_tags_log_stash.common_tags : key => value if value != ""
  }
  filtered_common_tags_data_sync = {
    for key, value in module.aws_resource_tags_data_sync.common_tags : key => value if value != ""
  }
}
