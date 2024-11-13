locals {
  awslogs_group = local.service_full_name

  environment_data = {
    PORT                   = local.container_port
    environment            = terraform.workspace
    ASPNETCORE_ENVIRONMENT = "Uat"
  }

  environment_array = [
    for k, v in local.environment_data : { name = tostring(k), value = tostring(v) }
  ]

  secrets_data = {
    AWS__AppKey              = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:AWS__AppKey::"
    AWS__AppSecret           = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:AWS__AppSecret::"
    AppSettings__ApiKey   = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:AppSettings__ApiKey::"
    ConnectionStrings__Read  = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:ConnectionStrings__Read::"
    ConnectionStrings__Write = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:ConnectionStrings__Write::"
    ElasticSearch__Password  = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:ElasticSearch__Password::"
    ElasticSearch__Username  = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:ElasticSearch__Username::"
    Seismic__ClientId        = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:Seismic__ClientId::"
    Seismic__ClientSecret    = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:Seismic__ClientSecret::"
    Seismic__UserId          = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:Seismic__UserId::"
    SalesForce__ClientId     = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:SalesForce__ClientId::"
    SalesForce__ClientSecret = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:SalesForce__ClientSecret::"
    SalesForce__Endpoint     = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:SalesForce__Endpoint::"
    SalesForce__ApiVersion   = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:/sep/${var.common_tags.Environment}/task_def-${local.secret_manager_arn_id}:SalesForce__ApiVersion::"
  }

  secrets_array = [
    for k, v in local.secrets_data : { name = tostring(k), valueFrom = tostring(v) }
  ]
}

#### DD Integration ######
module "frontend_api_dd_container" {
  source       = "../../modules/datadog_container"
  service_name = var.service_name
  tags         = var.common_tags
}


resource "aws_ecs_task_definition" "task_definition" {
  # container_definitions = data.template_file.task_definition.rendered
  family = local.service_full_name
  tags   = var.common_tags

  # Role that the Amazon ECS container agent and the Docker daemon can assume. For example to pull images and fetch secrets from PS/SSM.
  # Not to be confused with `task_role` (Task Role, Container role) - the role which running container could assume.
  # https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#execution_role_arn
  # See https://dillonbeliveau.com/2018/12/08/aws-ecs-iam-roles-demystified.html
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  # Role of the container during run time.
  # Not to be confused with Task Execution Role that the Amazon ECS container agent and the Docker daemon can assume.
  # https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#task_role_arn
  # See https://dillonbeliveau.com/2018/12/08/aws-ecs-iam-roles-demystified.html
  # Support for IAM roles for tasks was added to the AWS SDKs on July 13th, 2016 (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html)
  # task_role_arn = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    module.frontend_api_dd_container.fluentbit_container_definition,
    {
      "name" : local.service_full_name,
      "image" : local.container_image,
      "essential" : true,
      "cpu" : 100,
      "memoryReservation" : 700,
      "secrets" : local.secrets_array,
      "environment" : local.environment_array,
      "portMappings" : [
        {
          "name": "${local.service_full_name}-${local.container_port}-tcp",
          "containerPort" : local.container_port,
          "hostPort" : local.container_port,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : module.frontend_api_dd_container.service_container_definition_log_configuration,
      "dependsOn" : module.frontend_api_dd_container.service_container_definition_depends_on,
      # TODO: CHANGE TO TRUE AND FIX WRITING TO AVOID FUTURE DISK FILLING UP
      "readonlyRootFilesystem" : false,
      "volumesFrom" : [],
      "mountPoints" : [],
      "network_mode" : "bridge",
      "requires_compatibilities" : [],
    }
  ])
  # lifecycle {
  #   ignore_changes = [revision,container_definitions]
  # }
}

data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.task_definition.family
}

data "aws_caller_identity" "current" {}
