data "aws_caller_identity" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    region = var.aws_region
    bucket = join("-", [local.mhe_account_id, var.application, "infra-tfstate", local.account_type])
    key    = "env:/${local.account_type}/bab_infra-./shared.state.json"


    #bucket = join("-", [local.mhe_account_id, "remote-state", var.application, local.account_type])
    #key    = "env:/${local.account_type}/${var.application}-./shared.state.json"
  }
}
data "terraform_remote_state" "init" {
  backend = "s3"

  config = {
    region = var.aws_region
    bucket = join("-", [local.mhe_account_id, var.application, "infra-tfstate", local.account_type])
    key    = "env:/${local.account_type}/bab_infra-./init.state.json"


    #bucket = join("-", [local.mhe_account_id, "remote-state", var.application, local.account_type])
    #key    = "env:/${local.account_type}/${var.application}-./shared.state.json"
  }
}

# Default VPC is Amazon's. Non-default is usually provisioned for us
data "aws_vpc" "non-default" {
  # searching for the only provisioned VPC
  filter {
    name   = "tag-key"
    values = ["cloudformation:logical-id"]
  }

  filter {
    name   = "tag-value"
    values = ["VPC"]
  }
}

# data "aws_acm_certificate" "sep_cf_domain_certificate" {
#   domain = local.sep_cf_cert_hostname

#   statuses = ["ISSUED"]
# }

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.non-default.id]
  }
  tags = {
    subnet-type = "public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.non-default.id]
  }
  tags = {
    subnet-type = "private"
  }
}
data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}



# TODO: CHECK POTENTIAL DUPLICATE WITH MAIN.TF LOCAL
locals {
  resource_prefix = join("-", [module.aws_resource_tags.account, module.aws_resource_tags.application, module.aws_resource_tags.environment])
}
