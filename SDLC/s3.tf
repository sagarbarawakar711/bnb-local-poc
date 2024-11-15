

# # Identity used by CloudFront to access the S3 buckets
# resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
#   comment = "${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}"
# }
# output "origin_access" {
#   value = aws_cloudfront_origin_access_identity.origin_access_identity
# }
# ########################################
# #
# # S3 bucket for application code
# #
# ########################################

# data "aws_iam_policy_document" "sep_cf_s3_policy" {
#   depends_on = [aws_cloudfront_origin_access_identity.origin_access_identity]

#   # Policy statement #2: The origin access identity used by CloudFront is permitted to get any object
#   # in the blue application code bucket
#   statement {
#     sid     = "${module.aws_resource_tags.account}-${module.aws_resource_tags.environment}-access"
#     actions = ["s3:GetObject"]
#     resources = [
#       "arn:aws:s3:::${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-cf",
#       "arn:aws:s3:::${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-cf/*"
#     ]
#     principals {
#       type        = "AWS"
#       identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
#     }
#     condition {
#       test     = "Bool"
#       variable = "aws:SecureTransport"
#       values   = ["true"]
#     }
#   }
# }

# resource "aws_s3_bucket" "sep_cf_bucket" {
#   depends_on = [data.aws_iam_policy_document.sep_cf_s3_policy]

#   # Name of the bucket
#   bucket = "${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-cf"
#   # Access policy for the bucket
#   policy = data.aws_iam_policy_document.sep_cf_s3_policy.json
#   # Allow the bucket to be destroyed if not empty (all objects will be automatically destroyed first)
#   force_destroy = true

#   # Rule to handle CORS requests

#   cors_rule {
#     allowed_methods = ["GET"]
#     allowed_headers = []
#     expose_headers  = []
#     allowed_origins = var.cors_allowed_domain
#   }

#   lifecycle {
#     ignore_changes = [
#       cors_rule,
#       server_side_encryption_configuration,
#       policy
#     ]
#   }

#   # Tags to be applied to the bucket
#   tags = module.aws_resource_tags.common_tags

# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "sep_cf_bucket_encryption" {
#   bucket = aws_s3_bucket.sep_cf_bucket.bucket
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
# resource "aws_s3_bucket_versioning" "sep_cf_bucket_versioning" {
#   bucket = aws_s3_bucket.sep_cf_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # ########################################
# # #
# # # Initial S3 bucket contents for blue application code
# # #
# # ########################################

# resource "aws_s3_bucket_object" "sep_cf_deploy" {

#   bucket       = aws_s3_bucket.sep_cf_bucket.id
#   key          = "deployment-data.txt"
#   content_type = "text/plain"
#   #content       = "COLOR=blue"
#   cache_control = "no-store"

#   lifecycle {
#     ignore_changes = [content]
#   }
# }
