resource "aws_iam_role" "lambda_edge_role" {
  name = "${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-lambda-sqs-queue-listener-role"

  assume_role_policy = <<EOF
{
     "Version": "2012-10-17",
     "Statement": [
         {
             "Sid": "",
             "Effect": "Allow",
             "Principal": {
                 "Service": [
                     "lambda.amazonaws.com",
                     "edgelambda.amazonaws.com"
                 ]
             },
             "Action": "sts:AssumeRole"
         }
     ]
 }
EOF
}

resource "aws_iam_policy" "lambda_ses_sqs_policy" {
  name        = "lambda_ses_sqs_policy"
  description = "A policy that allows lambda function to read from SQS and send emails via SES"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ],
        Effect   = "Allow",
        Resource = module.sep_event.aws_sqs_sep_eventing_arn
      },
      {
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ses_sqs_policy_attach" {
  role       = aws_iam_role.lambda_edge_role.name
  policy_arn = aws_iam_policy.lambda_ses_sqs_policy.arn
}


resource "aws_lambda_function" "edge_lambda" {
  function_name    = "${module.aws_resource_tags.account}-${module.aws_resource_tags.application}-${module.aws_resource_tags.environment}-sqs-queue-listener"
  handler          = "AssetDeliveryLambda::AssetDeliveryLambda.Function::FunctionHandler"
  runtime          = "nodejs16.x"
  role             = aws_iam_role.lambda_edge_role.arn
  source_code_hash = filebase64sha256("function.zip")
  filename         = "function.zip"
  publish          = "true"
  timeout          = 180
  vpc_config {
    #vpc_id             = data.aws_vpc.non-default.id
    subnet_ids         = data.aws_subnets.private.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
  environment {
    variables = {
      ASPNETCORE_ENVIRONMENT = "Uat"
    }
  }
  # depends_on = [
  #   aws_iam_role_policy_attachment.sep_lambda_logs,
  #   aws_cloudwatch_log_group.sep_lambda_log_group,
  # ]
  tags = module.aws_resource_tags.common_tags
  lifecycle {
    ignore_changes = [
      runtime,
      source_code_hash
    ]
  }
}

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   output_path = "${path.module}/lambda.zip"
# }


resource "aws_lambda_event_source_mapping" "sep_lambda_map" {
  event_source_arn = module.sep_event.aws_sqs_sep_eventing_arn
  function_name    = aws_lambda_function.edge_lambda.arn
}
