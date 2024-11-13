#AWS EventBridge used as the event bus to enable 3rd party application events from
#SFDC and Seismic to be decoupled from the consuming clients (Sales Enablement
#Platform). Additionally, in the case of SFDC, the Sales Enablement platform push
#updates via the EventBridge to SFDC
resource "aws_cloudwatch_event_rule" "sep_eventbridge" {
  description         = "Schedule for 3rd party application events from SFDC and Seismic."
  is_enabled          = true
  name                = "${local.resource_prefix}-schedule"
  schedule_expression = local.eventbridge_schedule_expression
  tags                = var.common_tags
}

resource "aws_cloudwatch_event_target" "eventbridge_target_to_ecs" {
  rule     = aws_cloudwatch_event_rule.sep_eventbridge.name
  arn      = var.ecs_cluster_arn
  role_arn = var.oidc_role_arn

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.task_definition.arn
  }
}

