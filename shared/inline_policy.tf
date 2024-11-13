##############################################################
######## ECS Register containers Inline policy
##############################################################
resource "aws_iam_policy" "inline-policy" {
  name   = "ecs-container-inline-policy"
  count  = length(var.inline_policy)
  policy = file("./${element(var.inline_policy, count.index)}")
}

resource "aws_iam_role_policy_attachment" "inline-policy-attach" {
  count      = length(var.inline_policy)
  role       = module.aws_ecs_asg_cluster.iam_role.name
  policy_arn = aws_iam_policy.inline-policy.*.arn[count.index]
}

data "aws_iam_policy" "ssm_policy" {
  name = local.environment == "nonprod" ? "StackSet-CustomControlTower-CF-MH-SSM-SessionPreferences-3b12fcad-ccbe-4af6-9073-38eaa-SSMPrefsCustomResourcePolicy-mGQdxqyC3ba5" : "StackSet-CustomControlTower-CF-MH-SSM-SessionPreferences-beb497dd-7fbd-4955-ae98-5a47e-SSMPrefsCustomResourcePolicy-XpSwmoykrsFd"
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role       = module.aws_ecs_asg_cluster.iam_role.name
  policy_arn = data.aws_iam_policy.ssm_policy.arn
}
