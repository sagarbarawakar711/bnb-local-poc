# Instead of using bucket ID (name) from this resource, use the attribute of the last element in the chain of bucket resources:
#   = aws_s3_bucket_public_access_block.logs.bucket
#   = aws_s3_bucket_policy.logs_bucket_policy.bucket
# This will make sure that all required permissions are provisioned.
# Otherwise, modifying ALB to add access logs may fail due to race condition.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "logs" {
  # Restrictions apply for names: http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
  bucket = "${local.resource_prefix}-logs"

  # to allow destroy of non-empty bucket. all contents will be lost. Useful for dev/exp environments
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # We're going to use the same rule for all logs. However it's possible to
  #   distinguish by prefix if needed and to transition to cheaper storage class for longer periods.
  lifecycle_rule {
    id      = "logs"
    enabled = true

    expiration {
      days = 7
    }
  }

  tags = merge(
    local.filtered_common_tags,
    {
      "Function" = "logs"
    },
  )
}

# Instead of using bucket ID (name) from the bucket resource, use the attribute of policy resource:
#   = "${aws_s3_bucket_policy.logs_bucket_policy.bucket}"
# This will make sure that all required permissions are provisioned.
# Otherwise, modifying ALB to add access logs may fail due to race condition.
#
# MustBeEncryptedInTransit SID is managed by Turbot with eventual consistency.
# Second statement, AlbAccessLogs, is to allow ALBs to write logs to the bucket. Unfortunately, log-delivery-write is not enough
# Principal 127311923021 is from this page for us-east-1: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
# Bucket's Resource ARN should be adjusted if you want to use log prefixes
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket = aws_s3_bucket.logs.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "MustBeEncryptedInTransit",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.logs.id}",
                "arn:aws:s3:::${aws_s3_bucket.logs.id}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "AlbAccessLogs",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.self.account_id}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.logs.id}/AWSLogs/*"
        }
    ]
}
POLICY
}

# Blocking all public access to the bucket. Public buckets are discouraged from security perspective.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # HACK: force a dependency between various resources to avoid race condition between S3 API calls
  # See https://github.com/hashicorp/terraform-provider-aws/issues/7628
  depends_on = [aws_s3_bucket_policy.logs_bucket_policy]
}

# To check the existence of the function which is supposed to be created manually, once per account.
# Even plan will fail if it doesn't exist.
# See https://confluence.mheducation.com/display/NRM/S3+log+shipper+to+NewRelic+Logs
# data "aws_sns_topic" "lb-s3-log-ingestion" {
#   name = "sep-${local.account_type}-alb-datadog"
# }

# # Notification for Lambda function to send ALB logs to NewRelic
# # In the NewRelic logs, use the log bucket name pattern like this: `aws.s3_bucket_name:"*-${APPLICATION}-*prod-logs"`
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification
# resource "aws_s3_bucket_notification" "logs" {
#   bucket = aws_s3_bucket.logs.id

#   # For the ALB. Make sure the filter_prefix corresponds to the target function (ALB logs to the Lambda function with 'alb' log type environment variable)
#   topic {
#     # lambda_function_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:NewRelic-s3-log-ingestion"
#     topic_arn     = data.aws_sns_topic.lb-s3-log-ingestion.arn
#     events        = ["s3:ObjectCreated:*"]
#     filter_prefix = "AWSLogs/${data.aws_caller_identity.self.account_id}/elasticloadbalancing"
#   }

#   # HACK: force a dependency between various resources to avoid race condition between S3 API calls
#   # See https://github.com/hashicorp/terraform-provider-aws/issues/7628
#   depends_on = [aws_s3_bucket_public_access_block.logs]
# }
