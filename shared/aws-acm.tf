# Default SSL certificate for using in ALB's default HTTPS listener
# https://github.mheducation.com/terraform-incubator/aws-acm
module "aws_acm_default" {
  source = "git@github.mheducation.com:terraform/aws-acm.git?ref=3.3.0"


  # Max 64 characters for the first domain
  domain_name = local.alb_default_cert_name
  zone_id     = local.aws_route53_zone_id

  validation_force_overwrite = true
  wait_for_validation        = false

  tags = local.filtered_common_tags
}
# https://github.mheducation.com/terraform-incubator/aws-acm
module "aws_acm" {
  source = "git@github.mheducation.com:terraform/aws-acm.git?ref=3.3.0"

  for_each = local.sep_dns_names

  # Max 64 characters for the first domain
  domain_name               = each.key
  zone_id                   = local.aws_route53_zone_id
  subject_alternative_names = each.value

  validation_force_overwrite = true
  wait_for_validation        = false

  tags = local.filtered_common_tags
}

locals {
  sep_dns_names = terraform.workspace == "nonprod" ? {
    "bb.nonprod.uiplonline.com" = [
      "dev-api-admin.bb.nonprod.uiplonline.com", # Backend api nonprod
      "dev-api.bb.nonprod.uiplonline.com",       # Frontend api prod
      "dev-admin.bb.nonprod.uiplonline.com",     # Backend app nonprod
      "dev.bb.nonprod.uiplonline.com"            # Frontend app nonprod
    ],
    } : {
    "sep.mheducation.com" = [
      "api.admin.sep.mheducation.com", # Backend api prod
      "api.sep.mheducation.com",       # Frontend api prod
      "admin.sep.mheducation.com",     # Backend app prod
      "sep.mheducation.com"            #Frontend app prod
    ],
  }


  sep_cf_dns_name = local.account_type == "prod" ? {
    "static.sep.mheducation.com" = ["static.sep.mheducation.com", "prod-static.sep.mheducation.com"]
    } : {
    "dev-static.bb.nonprod.uiplonline.com" = [
      "dev-static.bb.nonprod.uiplonline.com",
      "static.bb.nonprod.uiplonline.com"
    ],
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate
resource "aws_lb_listener_certificate" "certificate_attach" {
  for_each        = local.sep_dns_names
  listener_arn    = module.aws_alb_http.listener.arn
  certificate_arn = module.aws_acm[each.key].certificate.arn
}

module "aws_acm_cf" {
  # Pinning to the current latest commit in master, since we haven't released a new version yet.
  source   = "git::ssh://git@github.mheducation.com/terraform/aws-acm.git?ref=3.3.0"
  for_each = local.sep_cf_dns_name

  # Max 64 characters for the first domain
  domain_name               = each.key
  zone_id                   = aws_route53_zone.main.zone_id
  subject_alternative_names = each.value

  validation_force_overwrite = true
  wait_for_validation        = false

  tags = local.filtered_common_tags
}
