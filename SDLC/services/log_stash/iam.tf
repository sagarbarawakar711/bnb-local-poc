##
# Define ESSENTIAL IAM resources. Allows side-loading of app-specific IAM policies.
#
# https://github.mheducation.com/terraform/diagrams/tree/master/iam-instance-profiles
# ------------------------------------------------------------------------------

# This is the policy which facilitates access between the ALB and the AWS service
# APIs. This policy is applied to the IAM role.
#
# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_understand.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user.html
data "aws_iam_policy_document" "logstash_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
      ]
    }
  }
}

# ------------------------------------------------------------------------------

# The IAM role gets attached to the instance profile.
# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "logstash_role" {

  # Apply the name based on an existing pattern
  name = "${local.service_full_name_without_account}-ecs-role"

  # Attach the policy defined below
  # https://www.terraform.io/docs/providers/aws/r/iam_role.html#example-of-using-data-source-for-assume-role-policy
  assume_role_policy = data.aws_iam_policy_document.logstash_assume_role_policy.json

  description = "The IAM role for the ECS containers."
  tags        = var.common_tags
}

# ------------------------------------------------------------------------------

# Essential IAM policies that NEED to be applied to all instances.
#
# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
data "aws_iam_policy_document" "logstash_ecs_policy" {

  # This is the policy which enables the ALB to assist in managing the ASG.
  statement {
    sid       = "ECSTaskManagement1"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]
  }

  # This is the policy which enables the ALB to learn about the EC2 instances.
  statement {
    sid       = "ECSTaskManagement2"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:Describe*",
      "ec2:DetachNetworkInterface"
    ]
  }

  statement {
    sid       = "AutoScaling"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "autoscaling:Describe*"
    ]
  }

  statement {
    sid       = "AutoScalingManagement"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "autoscaling:DeletePolicy",
      "autoscaling:PutScalingPolicy",
      "autoscaling:SetInstanceProtection",
      "autoscaling:UpdateAutoScalingGroup"
    ]
    condition {
      test     = "Null"
      values   = ["false"]
      variable = "autoscaling:ResourceTag/AmazonECSManaged"
    }
  }

  statement {
    sid       = "AutoScalingPlanManagement"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "autoscaling-plans:CreateScalingPlan",
      "autoscaling-plans:DeleteScalingPlan",
      "autoscaling-plans:DescribeScalingPlans"
    ]
  }

  statement {
    sid       = "CWAlarmManagement"
    effect    = "Allow"
    resources = ["arn:aws:cloudwatch:*:*:alarm:*"]
    actions = [
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm"
    ]
  }

  statement {
    sid       = "ECSTagging"
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:network-interface/*"]
    actions = [
      "ec2:CreateTags"
    ]
  }

  statement {
    sid       = "CWLogGroupManagement"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy"
    ]
  }

  statement {
    sid       = "CWLogStreamManagement"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
  }
}

# ------------------------------------------------------------------------------

# The policy definition above gets added to the "IAM policy" here.
#
# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "logstash_ecs_policy" {

  # Apply the name based on an existing pattern
  name = "${local.service_full_name_without_account}-ecs-service-policy"

  description = "Enables helping ECS Scaling and Capacity Provider Placement."

  # The IAM policy from above.
  policy = data.aws_iam_policy_document.logstash_ecs_policy.json
}

# ------------------------------------------------------------------------------

# Binds the policy (we just defined in the above two blocks) to the IAM role we
# created above.
#
# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.logstash_role.name
  policy_arn = aws_iam_policy.logstash_ecs_policy.arn
}
