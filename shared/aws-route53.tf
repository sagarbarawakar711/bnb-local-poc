# https://www.terraform.io/docs/providers/aws/r/route53_zone.html
# https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zone-public-considerations.html
### API
resource "aws_route53_zone" "main" {
  comment       = "Managed by Terraform"
  force_destroy = false
  name          = var.zone_name[local.account_type]
  tags          = local.filtered_common_tags
}


# https://www.terraform.io/docs/providers/aws/r/route53_record.html
### Backend API
resource "aws_route53_record" "backend_api_a_record_alias" {
  #for_each = var.aliases
  for_each = local.account_type == "prod" ? var.backend_api_prod : var.backend_api

  name    = each.value.dns_name
  type    = "A"
  zone_id = aws_route53_zone.main.zone_id


  alias {
    evaluate_target_health = false
    name                   = module.aws_alb_http.load_balancer.dns_name
    zone_id                = module.aws_alb_http.load_balancer.zone_id
  }
}
### Backend APP
resource "aws_route53_record" "backend_app_a_record_alias" {
  #for_each = var.aliases
  for_each = local.account_type == "prod" ? var.backend_app_prod : var.backend_app

  name    = each.value.dns_name
  type    = "A"
  zone_id = aws_route53_zone.main.zone_id


  alias {
    evaluate_target_health = false
    name                   = module.aws_alb_http.load_balancer.dns_name
    zone_id                = module.aws_alb_http.load_balancer.zone_id
  }
}

### Frontend API
resource "aws_route53_record" "frontend_api_a_record_alias" {
  #for_each = var.aliases
  for_each = local.account_type == "prod" ? var.frontend_api_prod : var.frontend_api

  name    = each.value.dns_name
  type    = "A"
  zone_id = aws_route53_zone.main.zone_id


  alias {
    evaluate_target_health = false
    name                   = module.aws_alb_http.load_balancer.dns_name
    zone_id                = module.aws_alb_http.load_balancer.zone_id
  }
}
### Frontend APP
resource "aws_route53_record" "frontend_app_a_record_alias" {
  #for_each = var.aliases
  for_each = local.account_type == "prod" ? var.frontend_app_prod : var.frontend_app

  name    = each.value.dns_name
  type    = "A"
  zone_id = aws_route53_zone.main.zone_id


  alias {
    evaluate_target_health = false
    name                   = module.aws_alb_http.load_balancer.dns_name
    zone_id                = module.aws_alb_http.load_balancer.zone_id
  }
}


locals {
  aws_route53_zone_id = aws_route53_zone.main.zone_id
  # Trimming trailing dot from the zone name for convenience of other resources.
  aws_route53_zone_name = trimsuffix(aws_route53_zone.main.name, ".")

  /* 
  aws_route53_zone_id_worker = aws_route53_zone.worker.zone_id
  # Trimming trailing dot from the zone name for convenience of other resources.
  aws_route53_zone_name_worker = trimsuffix(aws_route53_zone.worker.name, ".") */
}
