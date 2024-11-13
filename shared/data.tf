## TF Remote State to reference resources from Init layer in Shared
data "terraform_remote_state" "init" {
  backend = "s3"

   config = {
     region = var.aws_region
     # TODO: check if variables are allowed
     bucket = join("-", [local.mhe_account_id, var.application, "infra-tfstate", local.account_type])
     key    = "env:/${local.account_type}/bab_infra-./init.state.json"
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

data "aws_caller_identity" "self" {}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
