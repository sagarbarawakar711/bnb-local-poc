variable "aws_region" {
  description = "AWS region to put resources in."
  type        = string
  default     = "us-east-1"
}

#### ECS Services Domain Configurations

## Backedn API & APP
variable "backend_api" {
  # type = map(object({
  #   dns_name = string
  # }))
}
variable "backend_api_prod" {
  type = map(object({
    dns_name = string
  }))
}

variable "backend_app" {
  type = map(object({
    dns_name = string
  }))
}
variable "backend_app_prod" {
  type = map(object({
    dns_name = string
  }))
}

## Frontend API & APP
variable "frontend_api" {
  type = map(object({
    dns_name = string
  }))
}
variable "frontend_api_prod" {
  type = map(object({
    dns_name = string
  }))
}

variable "frontend_app" {
  type = map(object({
    dns_name = string
  }))
}
variable "frontend_app_prod" {
  type = map(object({
    dns_name = string
  }))
}

variable "zone_name" {
  description = "Fully qualified zone name, such as 'mysubdomain.nonprod.mheducation.com'"
  type        = map(string)
}

# some WAFv2 vars
variable "scope" {
  description = "Scope for WAF v2, REGIONAL or global Cloudfront"
  type        = string
  default     = "REGIONAL"
}

variable "default_rule_action" {
  description = "Default action for rules. True is block, false is allow."
  type        = string
  default     = "COUNT"
}

variable "waf_acl_default_action_block" {
  description = "Block by default?"
  type        = bool
  default     = false
}

variable "target_group_suffix_name_map" {
  description = "Target group suffix name for ECS services in SDLC layer"
  type        = map(list(string))
  default = {
    nonprod = ["dev", "qastg", "qalv", "qastg", "pqa", "demo"]
    prod    = ["blue", "green"]
  }
}

variable "turbot_account_config_map" {
  default = {
    nonprod = "aef"
    prod    = "aet"
  }
  description = "Turbot account three-letter ID, lowercase"
  type        = map(string)
}

variable "dead_letter_email_list" {
  description = "List of emails to subscribe to the dead letter SNS topic to receive various errors"
  type        = list(string)
  default     = []
}

