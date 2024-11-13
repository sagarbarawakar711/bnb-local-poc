##############################################################
######## ECS Register containers Inline policy
##############################################################
resource "aws_iam_policy" "s3_inline_policy" {
  name        = "s3-inline-policy"
  path        = local.iam_path_prefix
  description = "S3 policy to push files from ECS service."
  policy      = data.aws_iam_policy_document.sep_s3_policy.json
  tags        = local.filtered_common_tags
}

resource "aws_iam_role_policy_attachment" "s3_inline_policy_attach" {
  role       = data.terraform_remote_state.shared.outputs.aws_ecs_asg_cluster_iam_role
  policy_arn = aws_iam_policy.s3_inline_policy.arn
}
data "aws_iam_policy_document" "sep_s3_policy" {

  statement { # S3
    sid = "S3Access"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-cf",
      "arn:aws:s3:::${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-cf/*"
    ]
  }


}

##### Cloudwatch logging for Lambda
resource "aws_cloudwatch_log_group" "sep_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.edge_lambda.function_name}"
  retention_in_days = 14
}

data "aws_iam_policy_document" "sep_lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.sep_lambda_log_group.name}:*"]
  }
}

resource "aws_iam_policy" "sep_lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.sep_lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "sep_lambda_logs" {
  role       = aws_iam_role.lambda_edge_role.name
  policy_arn = aws_iam_policy.sep_lambda_logging.arn
}
