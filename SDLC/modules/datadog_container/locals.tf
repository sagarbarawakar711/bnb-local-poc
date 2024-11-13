locals {
  service_full_name   = join("-", [var.tags["Account"], var.tags["Application"], var.tags["Environment"], var.service_name])
  default_drop_filter = <<EOT
[FILTER]
    Name         grep
    Match        *
    Exclude      log ^\s*$
    Exclude      $log['sc-status'] 2[0-9][0-9]|3[0-9][0-9]
    Exclude      log 2[0-9][0-9]|3[0-9][0-9]
    Exclude      $log['level'] info|INFO|debug|DEBUG
    Exclude      log info|INFO|debug|DEBUG
EOT

  fluent_bit_config = templatefile("${path.module}/templates/fluentbit-configuration.conf", {
    account     = var.tags["Account"]
    environment = var.tags["Environment"]
    platform    = var.tags["Platform"]
    application = var.tags["Application"]
    drop_filter = length(var.replace_drop_filter) > 0 ? var.replace_drop_filter : local.default_drop_filter
  })

  fluent_bit_parsers = file("${path.module}/templates/fluentbit-custom-parsers.conf")

  fluentbit_container_definition = {
    command = [
      "bash",
      "-c", templatefile("${path.module}/templates/fluentbit-entrypoint.sh", {
        fluent_bit_config  = "'${replace(local.fluent_bit_config, "'", "'\\''")}'"
        fluent_bit_parsers = "'${replace(local.fluent_bit_parsers, "'", "'\\''")}'"
      })
    ]
    cpu       = 30
    essential = true
    firelensConfiguration = {
      type = "fluentbit"
      options = {
        enable-ecs-log-metadata = "true"
      }
    }
    image = "repo.mhe.io/docker/amazon/aws-for-fluent-bit:${var.aws_for_fluent_bit_image_version}"
    # image             = "public.ecr.aws/aws-observability/aws-for-fluent-bit:${var.aws_for_fluent_bit_image_version}"
    memoryReservation = 50
    name              = "${local.service_full_name}-log-router"
    secrets = [
      {
        name      = "DD_API_KEY"
        valueFrom = "/global/infra/datadog/default/org"
      }
    ]
    environment  = []
    mountPoints  = []
    portMappings = []
    volumesFrom  = []
    user         = "0" # TBD: check the right value
  }

  service_container_definition_depends_on = [
    {
      containerName = "${local.service_full_name}-log-router",
      condition     = "START"
    }
  ]

  service_container_definition_log_configuration = {
    logDriver = "awsfirelens"
  }
}
