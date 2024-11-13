# # Creates IPsets, regex and rule groups based on scope (REGIONAL | GLOBAL)
# # Attaches the rule group to FWManaged baseline WebACL

# module "wafv2_regional" {
#   source = "git@github.mheducation.com:terraform-incubator/aws-wafv2.git?ref=0.1.6"

#   ## Set default SQLi actions.
#   default_sql_injection_rule_action = "COUNT" # COUNT, ALLOW or BLOCK

#   # Rate Limit Rule Config
#   rate_rule_config = local.rate_rule_config_wafv2
#   #rule_group_capacity = 561


#   scope                 = "REGIONAL"
#   web_acl_name_to_fetch = "WAF-sep-rulegroup-regional-${module.aws_resource_tags.environment}"

#   #tags = module.aws_resource_tags.common_tags
#   tags = merge(module.aws_resource_tags.common_tags, { "Function" = "WAFv2" })

# }
# module "wafv2_global" {
#   source = "git@github.mheducation.com:terraform-incubator/aws-wafv2.git?ref=0.1.6"

#   ## Set default SQLi actions.
#   default_sql_injection_rule_action = "COUNT" # COUNT, ALLOW or BLOCK

#   # Rate Limit Rule Config
#   rate_rule_config = local.rate_rule_config_wafv2


#   scope                 = "CLOUDFRONT"
#   web_acl_name_to_fetch = "WAF-sep-rulegroup-global-${module.aws_resource_tags.environment}"

#   #tags = module.aws_resource_tags.common_tags
#   tags = merge(module.aws_resource_tags.common_tags, { "Function" = "WAFv2" })
# }

# locals {
#   rate_rule_config_wafv2 = [
#     # Example rule 1: Global rate limiting rule
#     {
#       action : "COUNT"
#       aggregate_key_type = "IP" # FORWARDED_IP or IP. Default: IP.
#       name : "${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-rate-global"
#       # Unique to this type
#       limit : 150 # per 5-minute interval.
#     }
#     // Add more rules as needed.
#   ]
# }
