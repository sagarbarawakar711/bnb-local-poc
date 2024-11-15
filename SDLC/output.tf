## Output of Backend API SDLC URLs
output "backend_api_sdlc_fqdn" {
  description = "FQDN to access services."
  value = {
    "backend_api" = local.backend_api_sdlc_fqdn
  }
}
## Output of Backend API DARK SDLC URLs
# output "backend_api_sdlc_fqdn_dark" {
#   description = "FQDN to access services."
#   value = {
#     "backend_api_dark" = local.backend_api_sdlc_fqdn_dark
#   }
# }
## Output of Frontend API SDLC URLs
output "frontend_api_sdlc_fqdn" {
  description = "FQDN to access services."
  value = {
    "frontend_api" = local.frontend_api_sdlc_fqdn
  }
}
## Output of Frontend API DARK SDLC URLs
# output "frontend_api_sdlc_fqdn_dark" {
#   description = "FQDN to access services."
#   value = {
#     "frontend_api_dark" = local.frontend_api_sdlc_fqdn_dark
#   }
# }
## Output of Backend APP SDLC URLs
output "backend_app_sdlc_fqdn" {
  description = "FQDN to access services."
  value = {
    "backend_app" = local.backend_app_sdlc_fqdn
  }
}
## Output of Backend APP DARK SDLC URLs
# output "backend_app_sdlc_fqdn_dark" {
#   description = "FQDN to access services."
#   value = {
#     "frontend_app_dark" = local.backend_app_sdlc_fqdn_dark
#   }
# }

# Output of Frontend APP DARK SDLC URLs
output "frontend_app_sdlc_fqdn" {
  description = "FQDN to access services."
  value = {
    "frontend_app_dark" = local.frontend_app_sdlc_fqdn
  }
}


## Output of Frontend APP DARK SDLC URLs
# output "frontend_app_sdlc_fqdn_dark" {
#   description = "FQDN to access services."
#   value = {
#     "frontend_app_dark" = local.frontend_app_sdlc_fqdn_dark
#   }
# }


# Output of Frontend APP DARK SDLC URLs
# output "origin_access_identity" {
#   value = {
#     "CF_origin_access_identity" = aws_cloudfront_origin_access_identity.origin_access_identity
#   }
# }
