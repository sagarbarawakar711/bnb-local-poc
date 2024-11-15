# resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
#   name    = "sep-${module.aws_resource_tags.environment}-security-headers-policy"
#   comment = "Adds security headers to SEP UI, behind BaaR."

#   security_headers_config {
#     content_type_options {
#       override = true
#     }
#     frame_options {
#       frame_option = "DENY"
#       override     = true
#     }
#     referrer_policy {
#       referrer_policy = "same-origin"
#       override        = true
#     }
#     xss_protection {
#       mode_block = true
#       protection = true
#       override   = true
#     }
#     strict_transport_security {
#       access_control_max_age_sec = "63072000"
#       include_subdomains         = true
#       preload                    = true
#       override                   = true
#     }
#     content_security_policy {
#       content_security_policy = "default-src 'self' data: 'unsafe-inline' *.edmesh.com *.nr-data.net *.newrelic.com *.mheducation.com *.gstatic.com *.mhedu.com *.pendo.io *.google-analytics.com *.googleapis.com *.googletagmanager.com wss://*.bootstrapcdn.com; frame-ancestors 'self';"
#       override                = true
#     }
#   }
#   /* custom_headers_config {
#     items {
#       header   = "Permissions-Policy"
#       value    = "accelerometer=(self)"
#       override = true
#     }
#   } */
# }
