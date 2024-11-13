# ########################################
# #
# # DNS records for CloudFront distributions
# #
# ########################################

# resource "aws_route53_record" "sep_cf_r53_record" {
#   zone_id = data.terraform_remote_state.shared.outputs.aws-dns-public-zone.hosted_zone.zone_id
#   name    = local.account_type == "prod" ? "static.sep.mheducation.com" : "${module.aws_resource_tags.environment}-static.sep.nonprod.mheducation.com"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.sep_cf_distro.domain_name
#     zone_id                = aws_cloudfront_distribution.sep_cf_distro.hosted_zone_id
#     evaluate_target_health = true
#   }
# }
