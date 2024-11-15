# resource "aws_security_group" "lambda_sg" {
#   name   = "sep_lambda_sg"
#   vpc_id = data.aws_vpc.non-default.id

#   ingress {
#     description = "VPC CIDR"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [data.aws_vpc.non-default.cidr_block]
#   }
#   ingress {
#     description     = "ZPA PROD"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     prefix_list_ids = ["pl-011da0f3bafc72348"]

#   }

#   ingress {
#     description     = "ZPA NONPROD"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     prefix_list_ids = ["pl-0ce308005cc4cfb63"]
#   }

#   ingress {
#     description     = "ZPA DC"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     prefix_list_ids = ["pl-04d72865ff6775dd8"]
#   }

#   ingress {
#     description     = "ZPA DC OUT"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     prefix_list_ids = ["pl-03e51023d30ad4f4e"]
#   }


#   egress {
#     description = "HTTPS Outbound"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     description = "SMTP STARTTLS OUT"
#     from_port   = 587
#     to_port     = 587
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "SMTP TLS Wrapper OUT"
#     from_port   = 465
#     to_port     = 465
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   tags = module.aws_resource_tags.common_tags
# }
