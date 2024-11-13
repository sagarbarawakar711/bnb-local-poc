locals {
  // This is the name used by the specific service, please create a new name if creating another service
  sep_eventing_sqs_service = join("-", [var.common_tags.Account, var.common_tags.Application, var.common_tags.Environment, "sep_event"])
}
