# Automatically generate tags for your AWS resources. https://confluence.mheducation.com/x/1CMFBw
# https://github.mheducation.com/terraform/aws-resource-tags

module "aws_resource_tags" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  #function    = var.function
  platform = var.platform
  runteam  = var.runteam
}

module "aws_resource_tags_backend_api" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "backend-api"
  platform    = var.platform
  runteam     = var.runteam
}

module "aws_resource_tags_backend_api_dark" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = "dark-${var.application}"
  environment = local.environment
  function    = "backend-api"
  platform    = var.platform
  runteam     = var.runteam
}


module "aws_resource_tags_frontend_api" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "frontend-api"
  platform    = var.platform
  runteam     = var.runteam
}

module "aws_resource_tags_frontend_api_dark" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = "dark-${var.application}"
  environment = local.environment
  function    = "frontend-api"
  platform    = var.platform
  runteam     = var.runteam
}


module "aws_resource_tags_backend_app" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "backend-app"
  platform    = var.platform
  runteam     = var.runteam
}

module "aws_resource_tags_backend_app_dark" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = "dark-${var.application}"
  environment = local.environment
  function    = "backend-app"
  platform    = var.platform
  runteam     = var.runteam
}


module "aws_resource_tags_frontend_app" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "frontend-app"
  platform    = var.platform
  runteam     = var.runteam
}

module "aws_resource_tags_frontend_app_dark" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = "dark-${var.application}"
  environment = local.environment
  function    = "frontend-app"
  platform    = var.platform
  runteam     = var.runteam
}

module "aws_resource_tags_log_stash" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "log-stash"
  platform    = var.platform
  runteam     = var.runteam
}
module "aws_resource_tags_data_sync" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "data-sync"
  platform    = var.platform
  runteam     = var.runteam
}

module "aws_resource_tags_sqs" {
  source      = "git@github.mheducation.com:terraform/aws-resource-tags.git?ref=5.1.0"
  account     = local.mhe_account_id
  application = var.application
  environment = local.environment
  function    = "sqs"
  platform    = var.platform
  runteam     = var.runteam
}
# Variables for the `aws-resource-tags` module.

variable "application" {
  description = "See https://confluence.mheducation.com/pages/viewpage.action?pageId=117777364"
  type        = string
}

variable "platform" {
  description = "NextGenAuthoring, connect, openlearning, connected, etc.. See https://confluence.mheducation.com/pages/viewpage.action?pageId=117777364"
  type        = string
}

variable "function" {
  description = "See https://confluence.mheducation.com/pages/viewpage.action?pageId=117777364"
  type        = string
  default     = ""
}

variable "runteam" {
  description = "See https://confluence.mheducation.com/pages/viewpage.action?pageId=117777364"
  type        = string
}
