resource "aws_sns_topic" "sep_sns_toppic" {
  name = "${local.name_prefix}_sns_topic"
  tags = local.filtered_common_tags
}

resource "aws_sns_topic_subscription" "sep_sns_sub" {
  topic_arn = aws_sns_topic.sep_sns_toppic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.edge_lambda.arn
}
