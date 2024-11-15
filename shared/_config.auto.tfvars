# These zones are expected to be present and externally managed just for safety.
# TODO: MOVE THIS TO .env
zone_name = {
  "nonprod" = "bb.nonprod.uiplonline.com",
  "prod"    = "prod.uiplonline.com",
}

inline_policy = [
  "register_container.json"
]

dead_letter_email_list = [
  "deadletter@mheducation.com", #SRE
]


## Nonprod & Prod domains for Backend API Service
backend_api = {
  dev_backend_api = {
    dns_name = "dev-api-admin.bb.nonprod.uiplonline.com"
  }

}

backend_api_prod = {
  prod_backend_api = {
    dns_name = "admin.api.prod.uiplonline.com"
  }
}


## Nonprod & Prod domains for Frontend API Service
frontend_api = {
  dev_frontend_api = {
    dns_name = "dev-api.bb.nonprod.uiplonline.com"
  }
}

frontend_api_prod = {
  prod_frontend_api = {
    dns_name = "api.prod.uiplonline.com"
  }
}


## Nonprod & Prod domains for Backend APP Service
backend_app = {
  dev_backend_app = {
    dns_name = "dev-admin.bb.nonprod.uiplonline.com"
  }
}

backend_app_prod = {
  prod_backend_app = {
    dns_name = "admin.prod.uiplonline.com"
  }
}

## Nonprod & Prod domains for Frontend APP Service
frontend_app = {
  dev_frontend_app = {
    dns_name = "dev.bb.nonprod.uiplonline.com"
  }
}

frontend_app_prod = {
  prod_frontend_app = {
    dns_name = "prod.uiplonline.com"
  }
}
