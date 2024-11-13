locals {
  environment            = var.tags["Environment"]
  application            = var.tags["Application"]
  function               = var.tags["Function"]
  account_type           = local.environment == "prod" ? "prod" : "nonprod"
  function_filtered_tags = { for k, v in var.tags : k => v if k != "Function" }
}
