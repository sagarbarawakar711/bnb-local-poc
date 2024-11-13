variable "aws_region" {
  description = "AWS Region to manage resources in."
  type        = string
  default     = "us-east-2"
}

variable "zone_name" {
  description = "Map of zone names for environments"
  type        = map(string)
}

variable "mhe_domain_name" {
  default = "mheducation.com"
}

variable "cors_allowed_domain" {
  type    = list(string)
  default = ["*.mheducation.com"]
}

variable "accounts_domain_prefix" {
  default = "accounts"
}

variable "log_level" {
  type    = string
  default = "info"
}

variable "log_file" {
  type    = string
  default = "application.log"
}
variable "log_appender" {
  type    = string
  default = "console"
}
