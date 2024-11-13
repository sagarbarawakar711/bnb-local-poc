locals {
  ## WAFv2/Shield Advanced Configurations

  ## Prod ALB
  prod_alb_names         = ["sep-prod-alb"]
  prod_alb_dns           = ["sep.mheducation.com","api.admin.sep.mheducation.com","api.sep.mheducation.com","admin.sep.mheducation.com"]
  prod_alb_resource_path = ["/api/healthcheck","/","/","/api/healthcheck"]


  ## Nonprod ALB
  nonprod_alb_names         = ["sep-nonprod-alb"]
  nonprod_alb_dns           = ["dev-api.sep.nonprod.mheducation.com", "dev.sep.nonprod.mheducation.com", "dev-admin.sep.nonprod.mheducation.com", "dev-api-admin.sep.nonprod.mheducation.com"]
  nonprod_alb_resource_path = ["/", "/api/healthcheck", "/api/healthcheck", "/"]

  ## Prod CloudFront
  prod_cf_ids           = ["E1KH0ZZTB4Y7B0"]
  prod_cf_endpoints     = ["static.sep.mheducation.com","prod-static.sep.mheducation.com"]
  prod_cf_resource_path = ["/"]


  ## Nonprod CloudFront
  nonprod_cf_ids           = ["E2TBEA9W91UWKM"]
  nonprod_cf_endpoints     = ["static.sep.nonprod.mheducation.com", "dev-static.sep.nonprod.mheducation.com"]
  nonprod_cf_resource_path = ["/"]


  effective_alb_name          = module.aws_resource_tags.environment == "prod" ? local.prod_alb_names : local.nonprod_alb_names
  effective_alb_endpoint      = module.aws_resource_tags.environment == "prod" ? local.prod_alb_dns : local.nonprod_alb_dns
  effective_alb_resource_path = module.aws_resource_tags.environment == "prod" ? local.prod_alb_resource_path : local.nonprod_alb_resource_path

  effective_cf_ids           = module.aws_resource_tags.environment == "prod" ? local.prod_cf_ids : local.nonprod_cf_ids
  effective_cf_endpoints     = module.aws_resource_tags.environment == "prod" ? local.prod_cf_endpoints : local.nonprod_cf_endpoints
  effective_cf_resource_path = module.aws_resource_tags.environment == "prod" ? local.prod_cf_resource_path : local.nonprod_cf_resource_path

  deny_addresses_ipv4  = []
  allow_addresses_ipv4 = []
}
