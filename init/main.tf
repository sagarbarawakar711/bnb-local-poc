# # https://github.mheducation.com/terraform-incubator/aws-iam-role-with-oidc/releases
# module "oidc_infra_role" {
#   source = "git@github.mheducation.com:terraform-incubator/aws-iam-role-with-oidc.git?ref=1.0.0"

#   role_path              = local.iam_path_prefix
#   role_name_suffix       = "infra"
#   provider_urls          = ["https://github.mheducation.com/_services/token"]
#   iam_policies_to_attach = local.infra_custom_managed_policies
#   github_repositoies     = ["torchwood/sep-infrastructure", "Sales-Enablement-Platform/*"]
#   # Tags
#   tags = module.aws_resource_tags.common_tags
# }
provider "aws" {
  region = var.aws_region
}

provider "null" {
}

