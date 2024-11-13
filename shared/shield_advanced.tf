module "shield_advanced" {
  source = "git@github.mheducation.com:terraform-incubator/aws-shield-advanced.git?ref=0.1.6"
  # Current Supported resources to be shielded - the values can be present even if you're not including them in shield.
  # Any of these keys without the values below will be ignored.
  resource_types = ["alb", "cloudfront"]

  ### ALB Recourse configurations ####
  ## The name of the alb you want shield protection
  alb_names = local.effective_alb_name
  ## ALB 5xx alaram configs
  alb_comparison_operator = "GreaterThanOrEqualToThreshold" # Default set to: "GreaterThanOrEqualToThreshold"
  alb_evaluation_periods  = 5                               # Default set to: 5
  alb_alarm_metric_name   = "HTTPCode_ELB_5XX_Count"        # Default set to: "HTTPCode_ELB_5XX_Count"
  alb_alarm_threshold     = 10                              # Default set to: 10
  alb_alarm_statistic     = "Average"                       # Default set to: "Average"
  alb_alarmn_namespace    = "AWS/ApplicationELB"            # Default set to: "AWS/ApplicationELB"
  alb_alarm_period        = 60                              # Default set to: 60

  ## ALB target response Time alarms configs
  alb_response_comparison_operator = "GreaterThanOrEqualToThreshold" # Default set to: "GreaterThanOrEqualToThreshold"
  alb_response_evaluation_periods  = 2                               # Default set to: 2
  alb_response_alarm_metric_name   = "TargetResponseTime"            # Default set to: "TargetResponseTime"
  alb_response_alarm_threshold     = 60                              # Default set to: 60 sec
  alb_response_alarm_statistic     = "Maximum"                       # Default set to: "Maximum"
  alb_response_alarmn_namespace    = "AWS/ApplicationELB"            # Default set to: "AWS/ApplicationELB"
  alb_response_period              = 300                             # Default set to: 300

  ## ALB Endpoint Healh Checks
  alb_endpoint_check_port              = 443                               # Default set to: 80
  alb_endpoint_check_type              = "HTTPS"                           # Default set to: "HTTP"
  alb_endpoint_check_resource_path     = local.effective_alb_resource_path # Default set to: "/"
  alb_endpoint_check_failure_threshold = "5"                               # Default set to: "5"
  alb_endpoint_check_request_interval  = "30"                              # Default set to: "30"
  alb_dns_endpoint                     = local.effective_alb_endpoint      # Define DNS endpoint


  ## ALB Calculated Health Checks
  alb_calculated_type                   = "CALCULATED" # Default protocol set to: "CALCULATED"
  alb_calculated_child_health_threshold = 2            # Default minum number of child health checks set to: 2

  ### Cloudfront resource configurations ####
  ##  The cloudfront distribution IDs you want shield protection.
  cloudfront_distribution_ids = local.effective_cf_ids
  ## CF 5xx alarm configs
  cf_comparison_operator = "GreaterThanOrEqualToThreshold" # Default set to: "GreaterThanOrEqualToThreshold"
  cf_evaluation_periods  = 5                               # Default set to: 5
  cf_alarm_metric_name   = "5xxErrorRate"                  # Default set to: "5xxErrorRate"
  cf_alarm_threshold     = 10                              # Default set to: 10
  cf_alarm_statistic     = "Average"                       # Default set to: "Average"
  cf_alarmn_namespace    = "AWS/CloudFront"                # Default set to: "AWS/CloudFront"
  cf_alarm_period        = 60                              # Default set to: 60

  ## CF latencyalarms configs
  cf_latency_comparison_operator = "GreaterThanOrEqualToThreshold" # Default set to: "GreaterThanOrEqualToThreshold"
  cf_latency_evaluation_periods  = 5                               # Default set to: 5
  cf_latency_alarm_metric_name   = "AVG(OriginLatency)"            # Default set to: "AVG(OriginLatency)"
  cf_latency_alarm_threshold     = 30                              # Default set to: 30
  cf_latency_alarm_statistic     = "Average"                       # Default set to: "Average"
  cf_latency_alarmn_namespace    = "AWS/CloudFront"                # Default set to:  "AWS/CloudFront"
  cf_latency_alarm_period        = 60                              # Default set to: 60

  ## CF Endpoint Healh Checks
  cf_endpoint_check_port              = 443                              # Default set to: 80
  cf_endpoint_check_type              = "HTTPS"                          # Default set to: "HTTP"
  cf_endpoint_check_resource_path     = local.effective_cf_resource_path # Default set to: "/"
  cf_endpoint_check_failure_threshold = "5"                              # Default set to: "5"
  cf_endpoint_check_request_interval  = "30"                             # Default set to: "30"
  cf_dns_endpoint                     = local.effective_cf_endpoints     # Define DNS endpoint

  ## CF Calculated Health Checks
  cf_calculated_type                   = "CALCULATED" # Default protocol set to: "CALCULATED"
  cf_calculated_child_health_threshold = 2

  #tags = module.aws_resource_tags.common_tags
  tags = merge(module.aws_resource_tags.common_tags, { "Function" = "shield" })
}
