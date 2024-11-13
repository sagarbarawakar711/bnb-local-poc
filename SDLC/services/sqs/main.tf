/****************************************************************
# REQUIREMENTS
The local variable service._full_name has to be set properly to name the service below. It is constructed by using the following variables from the variables.tf file:
  join("-", [var.common_tags.Account, var.common_tags.Application, var.common_tags.Environment, var.service_name]
*****************************************************************/

resource "aws_sqs_queue" "sep_eventing" {
  name                       = local.sep_eventing_sqs_service
  visibility_timeout_seconds = 180
  tags                       = var.common_tags
}
