# Local (used only in this file) variable definitions
locals {
  s3OriginPrefix       = "myS3Origin"
  accountsOriginPrefix = "accountsorigin"
  nonprod_tags = merge(module.aws_resource_tags.common_tags, {
    "FWManaged-sep-nonprod" = "true"
  })

  prod_tags = merge(module.aws_resource_tags.common_tags, {
    "FWManaged-sep-prod" = "true"
  })
}

data "aws_s3_bucket" "logs" {
  bucket = "${local.s3_logs_bucket_prefix}-logs"
}

########################################
#
# CloudFront  distribution
#
########################################

resource "aws_cloudfront_distribution" "sep_cf_distro" {
  depends_on      = [aws_cloudfront_origin_access_identity.origin_access_identity]
  enabled         = true
  is_ipv6_enabled = true
  comment         = "SEP-${module.aws_resource_tags.environment}"

  aliases = [
    "${local.environment == "prod" ? "static.sep.${var.mhe_domain_name}" : "static.sep.nonprod.mheducation.com"}",
    "${local.environment == "prod" ? "prod-static.sep.${var.mhe_domain_name}" : "${module.aws_resource_tags.environment}-static.sep.nonprod.mheducation.com"}",
  ]


  origin { #1: S3 application code bucket 
    domain_name = aws_s3_bucket.sep_cf_bucket.bucket_regional_domain_name
    origin_id   = local.s3OriginPrefix
    #origin_path = "/static"


    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }


  # origin {
  #   domain_name = local.environment == "prod" ? "${var.accounts_domain_prefix}.${var.mhe_domain_name}" : "${var.accounts_domain_prefix}-${module.aws_resource_tags.environment}.${var.mhe_domain_name}"
  #   origin_id   = local.accountsOriginPrefix

  #   custom_origin_config {
  #     http_port              = 80
  #     https_port             = 443
  #     origin_protocol_policy = "https-only"
  #     origin_ssl_protocols   = ["TLSv1.2"]
  #   }
  # }

  # Object to return if requested path is the bucket root
  default_root_object = "index.html"

  # Default behavior for all requests
  default_cache_behavior {
    # Only allowed to retrieve objects from S3 bucket
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3OriginPrefix

    # What parts of the request get forwarded to the origin
    forwarded_values {
      query_string = false
      headers      = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]

      cookies {
        forward = "none"
      }
    }

    # Which protocols can be used to access the distribution
    viewer_protocol_policy = "redirect-to-https"

    # Communication settings
    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
    compress    = true

    ## Response Headers Policy
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id
  }


  # Collection of edge locations to use (will always serve to entire world):
  #   -- Use "PriceClass_100" in non-prod (U.S., Canada, and Europe edge locations only)
  #   -- Use "PriceClass_All" in prod (all edge locations)
  price_class = "PriceClass_100"

  # Restrictions on which regions can be served by this distribution
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Where to store access logs
  logging_config {
    #bucket = "${module.alb.access_log_bucket_name}"
    bucket = data.aws_s3_bucket.logs.bucket_domain_name
    prefix = "SEP-CloudFront/"
  }

  # Tags to be applied to the distribution
  tags = module.aws_resource_tags.environment != "prod" ? local.nonprod_tags : local.prod_tags

  # TLS configuration for the distribution
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.sep_cf_domain_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Custom error responses
  #
  # For 400 (bad request), display the home page
  custom_error_response {
    error_code         = 400
    response_code      = 200
    response_page_path = "/index.html"
  }

  # For 403 (permission denied), display the home page
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  # For 404 (not found), display the home page
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }
  lifecycle {
    ignore_changes = [origin, web_acl_id]
  }
}
