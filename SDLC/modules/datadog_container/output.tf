output "fluentbit_container_definition" {
  value = local.fluentbit_container_definition
}

output "service_container_definition_depends_on" {
  value = local.service_container_definition_depends_on
}

output "service_container_definition_log_configuration" {
  value = local.service_container_definition_log_configuration
}
