#
# More granular our manually managed policy. Managed policies usually give more rights then needed
#

# Policies for Infrastructure role
# --------------------------------------------------------------------------------------

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "infra_custom_managed_policy_misc" {
  name        = "${local.role_prefix_name}-manual-policy-misc"
  path        = local.iam_path_prefix
  description = "More granular access to resources in one policy due to default limits of policy number allowed to attach to a user or a group. Terraform managed"
  policy      = data.aws_iam_policy_document.infra_custom_managed_policy_misc.json
  tags        = local.filtered_common_tags
}

resource "aws_iam_policy" "infra_custom_managed_policy_iam" {
  name        = "${local.role_prefix_name}-manual-policy-iam"
  path        = local.iam_path_prefix
  description = "More granular access to IAM resources in one policy due to default limits of policy number allowed to attach to a user or a group. Terraform managed"
  policy      = data.aws_iam_policy_document.infra_custom_managed_policy_iam.json
  tags        = local.filtered_common_tags
}

resource "aws_iam_policy" "infra_custom_managed_policy_waf" {
  name        = "${local.role_prefix_name}-manual-policy-waf"
  path        = local.iam_path_prefix
  description = "More granular access to WAF Regional  resources in one policy due to default limits of policy number allowed to attach to a user or a group. Terraform managed"
  policy      = data.aws_iam_policy_document.infra_custom_managed_policy_waf.json
  tags        = local.filtered_common_tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "infra_custom_managed_policy_misc" {
  statement { # AllResources
    sid = "VisualEditor0"

    actions = [
      "ssm:PutParameter",
      "firehose:Update*",
      "firehose:*DeliveryStreamEncryption",
      "firehose:*DeliveryStream",
      "events:UntagResource",
      "events:TagResource",
      "events:*Targets",
      "events:*TagsForResource",
      "events:*Rule",
    ]

    resources = [
      "arn:aws:ssm:us-east-1:${local.aws_account_id}:parameter/${var.application}*",
    ]
  }

  statement { # CloudWatch
    sid = "VisualEditor1"

    actions = [
      "ses:SetIdentityMailFromDomain",
      "ssm:PutI*",
      "ssm:UpdateA*",
      "cloudwatch:PutDashboard",
      "application-autoscaling:*",
      "cloudwatch:PutMetricData",
      "acm:DeleteCertificate",
      "ses:VerifyEmailIdentity",
      "cloudwatch:DeleteAlarms",
      "ssm:CreateAs*",
      "logs:*",
      "ssm:UpdateI*",
      "ses:GetIdentityMailFromDomainAttributes",
      "autoscaling:*",
      "ses:DeleteIdentityPolicy",
      "ses:GetIdentityDkimAttributes",
      "ssm:G*",
      "acm:RequestCertificate",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:ListDashboards",
      "cloudwatch:ListTagsForResource",
      "ses:SetIdentityNotificationTopic",
      "ssm:Des*",
      "cloudwatch:GetDashboard",
      "ssm:DeregisterM*",
      "ses:PutIdentityPolicy",
      "ssm:RegisterT*",
      "acm:AddTagsToCertificate",
      "ses:GetIdentityVerificationAttributes",
      "cloudwatch:GetMetricStatistics",
      "ssm:L*",
      "cloudwatch:DescribeAlarms",
      "ecs:*",
      "ec2:*",
      "ssm:Ca*",
      "cloudwatch:GetMetricData",
      "ssm:Sto*",
      "ses:GetIdentityPolicies",
      "ssm:UpdateMaintenanceWindowT*",
      "ses:VerifyDomainDkim",
      "ssm:DeregisterT*",
      "cloudwatch:ListMetrics",
      "ses:VerifyDomainIdentity",
      "ssm:Se*",
      "ssm:DeletePar*",
      "ses:SetIdentityHeadersInNotificationsEnabled",
      "ssm:Rem*",
      "cloudwatch:DeleteDashboards",
      "ssm:A*",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DisableAlarmActions",
      "cloudfront:GetDistribution",
      "cloudfront:ListTagsForResource",
      "wafv2:*",
      "cloudwatch:SetAlarmState",
      "ssm:StartA*",
      "cloudwatch:GetMetricWidgetImage",
      "s3:*",
      "elasticloadbalancing:*",
      "ses:GetIdentityNotificationAttributes",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:EnableAlarmActions",
      "ssm:PutCon*",
      "route53:*",
      "ses:DeleteIdentity",
      "ecr:*",
      "ssm:DeleteAs*",
      "elasticache:*",
      "acm:*",
    ]

    resources = ["*"]
  }

  statement { # SNS
    sid = "SNS"

    actions = [
      "sns:*",
    ]
    resources = [
      "arn:aws:sns:us-east-1:${local.aws_account_id}:${module.aws_resource_tags.account}-${var.application}-*",
      "arn:aws:sns:us-east-1:${local.aws_account_id}:ddos-detected", #from shield
    ]
  }

}

data "aws_iam_policy_document" "infra_custom_managed_policy_iam" {
  statement { # IAMPolicy resources: "aws_iam_policy"
    sid = "IAMPolicy"

    actions = [
      "iam:*Policy*",
    ]

    resources = [
      "arn:aws:iam::${local.aws_account_id}:policy/*${var.application}*",            #include custom paths
      "arn:aws:iam::${local.aws_account_id}:policy/mh-ssm-managed-instance-policy",  #from shared
      "arn:aws:iam::${local.aws_account_id}:policy/lambda_logging_shield_tf_policy", #from shield advance module
    ]
  }

  statement { # IAMRole resources: "aws_iam_role", "aws_iam_role_policy_attachment"
    sid = "IAMRole"

    actions = [
      "iam:*Role*",
    ]

    resources = [
      "arn:aws:iam::${local.aws_account_id}:role/*${var.application}*",          #include custom paths
      "arn:aws:iam::${local.aws_account_id}:role/terraform-*",                   #lambda ECS
      "arn:aws:iam::${local.aws_account_id}:role/lambda_logging_shield_tf_role", #from shield advance module
    ]
  }

  statement { # IAMInstanceProfile resouces: "iam_instance_profile"
    sid = "IAMInstanceProfile"

    actions = [
      "iam:*InstanceProfile*",
    ]

    resources = [
      "arn:aws:iam::${local.aws_account_id}:instance-profile/*${var.application}*", #include custom paths
    ]
  }
}

data "aws_iam_policy_document" "infra_custom_managed_policy_waf" {
  statement { # WAFRegionalAll
    sid = "WAFRegionalAll"

    actions = [
      "waf-regional:GetChangeToken",
    ]

    resources = ["*"]
  }

  statement { # WAFRegional
    sid = "WAFRegional"

    actions = [
      "waf-regional:UntagResource",
      "waf-regional:TagResource",
      "waf-regional:*XssMatchSet",
      "waf-regional:*WebACL",
      "waf-regional:*TagsForResource",
      "waf-regional:*SqlInjectionMatchSet",
      "waf-regional:*Rule",
      "waf-regional:*RateBasedRule",
      "waf-regional:*LoggingConfiguration",
      "waf-regional:*IPSet",
      "waf-regional:GetWebACLForResource",
      "application-autoscaling:ListTagsForResource",
      "autoscaling:DescribeScalingActivities",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:ListTagsForResource",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeManagedPrefixLists",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcs",
      "ecs:UntagResource",
      "ecs:ListTagsForResource",
      "ec2:GetManagedPrefixListEntries",
      "elasticloadbalancing:RemoveTags",
      "iam:UntagRole",
      "route53:CreateHealthCheck",
      "route53:GetHealthCheck",
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
      "shield:CreateProtection",
      "shield:DescribeProtection",
      "shield:EnableApplicationLayerAutomaticResponse",
      "shield:ListTagsForResource",
      "shield:TagResource",
      "wafv2:*",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "ec2:DescribeRegions",
      "cloudfront:GetDistribution",
      "cloudfront:ListTagsForResource",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeTags",
      "shield:EnableApplicationLayerAutomaticResponse",
      "SNS:CreateTopic",
      "SNS:TagResource",
      "SNS:SetTopicAttributes",
      "SNS:GetTopicAttributes",
      "SNS:ListTagsForResource",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:Unsubscribe",
      "SNS:GetSubscriptionAttributes",
      "cloudwatch:TagResource",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "shield:CreateProtection",
      "iam:CreateRole",
      "iam:GetRole",
      "iam:TagRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:ListTagsLogGroup",
      "logs:DescribeLogStreams",
      "shield:TagResource",
      "cloudwatch:DeleteAlarms",
      "iam:ListInstanceProfilesForRole",
      "logs:DeleteLogGroup",
      "iam:CreatePolicy",
      "iam:GetPolicyVersion",
      "iam:GetPolicy",
      "route53:DeleteHealthCheck",
      "shield:DescribeProtection",
      "shield:ListTagsForResource",
      "route53:ListHealthChecks",
      "route53:ChangeTagsForResource",
      "shield:DeleteProtection",
      "iam:DeleteRole",
      "iam:ListPolicyVersions",
      "iam:DeletePolicy",
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:ListFunctions",
      "lambda:GetFunction",
      "iam:PassRole",
      "iam:AttachRolePolicy",
      "lambda:PutFunctionConcurrency",
      "lambda:ListVersionsByFunction",
      "shield:AssociateHealthCheck",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "route53:UpdateHealthCheck",
      "lambda:RemovePermission",
      "shield:DisassociateHealthCheck",
      "iam:DetachRolePolicy",
      "logs:DeleteLogStream",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:CreatePolicyVersion",
      "lambda:UpdateFunctionConfiguration",
      "wafv2:UpdateWebACL",
      "sqs:sendmessage"
    ]

    resources = [
      "arn:aws:events:us-east-1:${local.aws_account_id}:rule/*${var.application}*",
      "arn:aws:firehose:us-east-1:${local.aws_account_id}:deliverystream/*${var.application}*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:loadbalancer/app/*${var.application}*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:ratebasedrule/*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:xssmatchset/*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:sqlinjectionset/*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:webacl/*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:ipset/*",
      "arn:aws:waf-regional:us-east-1:${local.aws_account_id}:changetoken/*",
    ]
  }

  statement { # Shield
    sid = "Shield"

    actions = [
      "shield:*",
    ]

    resources = [
      "arn:aws:shield::${local.aws_account_id}:protection/*", # random id
    ]
  }

}
