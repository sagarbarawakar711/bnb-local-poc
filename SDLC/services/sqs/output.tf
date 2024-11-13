output "aws_sqs_sep_eventing_url" {
  description = "Url of the SEP EventBrige sqs"
  value       = aws_sqs_queue.sep_eventing.id
}
output "aws_sqs_sep_eventing_arn" {
  description = "Url of the SEP EventBrige sqs"
  value       = aws_sqs_queue.sep_eventing.arn
}

output "sep_eventing_sqs_service_name" {
  description = "Name of the service applied to the SEP sqs"
  value       = local.sep_eventing_sqs_service
}
