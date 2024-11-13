variable "task_min_count_config_map" {
  default = {
    dev  = 1
    prod = 1
  }
  description = "Minimum number of tasks to keep running when scaling in"
  type        = map(number)
}

variable "task_max_count_config_map" {
  default = {
    dev  = 1
    prod = 1
  }
  description = "Maximum number of tasks to run when scaling out"
  type        = map(number)
}

variable "task_cpu_target_percent_config_map" {
  default = {
    dev  = 70
    prod = 70
  }
  description = "CPU threshold used for auto-scaling in percent CPU available to the task"
  type        = map(number)
}

variable "task_memory_target_percent_config_map" {
  default = {
    dev  = 70
    prod = 70
  }
  description = "Memory threshold used for auto-scaling in percent memory available to the task"
  type        = map(number)
}

variable "task_healthcheck_timeout_in_seconds_config_map" {
  default = {
    dev  = 10
    prod = 300
  }
  description = "Number of seconds the load balancer will wait for the task to become healthy"
  type        = map(number)
}

variable "deregistration_delay_seconds_config_map" {
  description = "Number of seconds to wait before changing the state of a deregistering target from _draining_ to _unused_. Range is `0`–`3600` seconds."
  default = {
    dev  = 5
    prod = 300
  }
  type = map(number)
}

variable "start_delay_seconds_config_map" {
  description = "Number of seconds for targets to warm-up before sending them a full share of requests. Range is `30`–`900` seconds or `0` to disable."
  default = {
    dev  = 30
    prod = 30
  }
  type = map(number)
}

variable "secret_manager_arn_id" {
  default = {
    dev  = "ky2hEM"
    prod = "omi03q"
  }
  type = map(string)
}

variable "task_placement_strategy_rules" {
  description = "The service-level strategy rules taken into consideration during task placement. Order is significant. Takes place on the next deployment unless `force_new_deployment` is set to `true`."
  type = list(object({
    type  = string
    field = string
  }))
  default = [
    { "type" = "spread", "field" = "attribute:ecs.availability-zone" },
    { "type" = "binpack", "field" = "memory" },
    { "type" = "binpack", "field" = "cpu" },
  ]
}

