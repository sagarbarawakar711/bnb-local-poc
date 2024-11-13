resource "aws_security_group" "sep_nonprod" {
  name   = "sep_nonprod_sg"
  vpc_id = data.aws_vpc.non-default.id

  ingress {
    description     = "ZPA PROD"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-011da0f3bafc72348"]

  }

  ingress {
    description     = "ZPA NONPROD"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-0ce308005cc4cfb63"]
  }

  ingress {
    description     = "ZPA DC"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-04d72865ff6775dd8"]
  }

  ingress {
    description     = "ZPA DC OUT"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-03e51023d30ad4f4e"]
  }
  ingress {
    description = "VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.non-default.cidr_block]
  }



  tags = local.filtered_common_tags

}

data "aws_security_group" "FW_Manager_WebPublic_SG" {
  id = local.FW_Manager_WebPublic_SG
}


data "aws_security_group" "FW_Manager_Default_SG" {
  id = local.FW_Manager_Default_SG
}


variable "FW_Manager_WebPublic_SG" {
  default = {
    nonprod = "sg-0576079fa168b3cab"
    prod    = "sg-0a2a1ba75fc680810"
  }
  type = map(string)
}
variable "FW_Manager_Default_SG" {
  default = {
    nonprod = "sg-0f7dff51dcbd31e88"
    prod    = "sg-0064ac2eb9c706625"
  }
  type = map(string)
}


locals {
  FW_Manager_WebPublic_SG = var.FW_Manager_WebPublic_SG[terraform.workspace]
  FW_Manager_Default_SG   = var.FW_Manager_Default_SG[terraform.workspace]
}
