# # Application Load Balancer optimized for clusters which respond over HTTP.
# # https://github.mheducation.com/terraform-incubator/aws-alb-http
module "aws_alb_http" {
  source = "git@github.mheducation.com:terraform/aws-alb-http.git?ref=2.5.0"

  # General configuration
  deletion_protection = local.alb_deletion_protection
  enable_ipv6         = false # Our VPCs currenty do not support ipv6
  external            = true

  deregistration_delay_seconds = local.alb_deregistration_delay_seconds

  # Logging
  logging_enabled = false
  #logging_s3_bucket = aws_s3_bucket_public_access_block.logs.bucket

  # Providing default certificate just to create the ALB. Each environment will supply its own certificate and listener rules
  # Terraform will stuck on attempt to replace it due to chicken and egg issue in AWS plugin. You can manually set default listener's cert to something else to help.
  # Using element() with explicit dependency on validation resources due to current implementation of AWS_ACM module which doesn't wait properly
  acm_cert_arn = element(concat([module.aws_acm_default.certificate.arn], module.aws_acm_default.certificate_validation.*.id), 0)

  user_port     = 443
  user_protocol = "HTTPS"

  #Healthcheck
  healthcheck_path     = local.alb_healthcheck_path
  healthcheck_port     = local.alb_healthcheck_port
  healthcheck_protocol = local.alb_healthcheck_protocol

  # Tags
  tags = terraform.workspace == "prod" ? local.prod_waf : local.nonprod_waf

  # Network/VPC configuration
  vpc_id  = data.aws_vpc.non-default.id
  subnets = data.aws_subnets.public.ids
  security_groups = [
    data.aws_security_group.FW_Manager_WebPublic_SG.id,
    data.aws_security_group.FW_Manager_Default_SG.id,
    aws_security_group.sep_nonprod.id,
    module.aws_ec2_alb_sg.alb_security_group.id
  ]
}

## Redirect HTTP to HTTPS - not needed for this project
resource "aws_lb_listener" "http_to_https_redirect" {
  load_balancer_arn = module.aws_alb_http.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  tags              = local.filtered_common_tags

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}




locals {
  prod_waf    = merge(local.filtered_common_tags, { "FWManaged-sep-prod" = true })
  nonprod_waf = merge(local.filtered_common_tags, { "FWManaged-sep-nonprod" = true })
}
# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "alb_default_alias" {
  zone_id = local.aws_route53_zone_id
  type    = "A"
  name    = local.alb_default_cert_name

  alias {
    name                   = module.aws_alb_http.load_balancer.dns_name
    zone_id                = module.aws_alb_http.load_balancer.zone_id
    evaluate_target_health = false
  }
}
