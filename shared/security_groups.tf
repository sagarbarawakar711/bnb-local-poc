resource "aws_security_group" "sep_nonprod" {
  name   = "sep_nonprod_sg"
  vpc_id = data.aws_vpc.non-default.id

  # ingress {
  #   description     = "ZPA PROD"
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   prefix_list_ids = ["pl-011da0f3bafc72348"]

  # }

  ingress {
    description     = "ZPA NONPROD"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-087c4faad4fe90b60"]
  }

  ingress {
    description     = "ZPA DC"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-02903563b1eaa3600"]
  }

  ingress {
    description     = "ZPA DC OUT"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-0b698d6d9f2a60003"]
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
    nonprod = "sg-0883632b00576fe05"
    prod    = "sg-0a2a1ba75fc680810"
  }
  type = map(string)
}
variable "FW_Manager_Default_SG" {
  default = {
    nonprod = "sg-0abdfef21914622b2"
    prod    = "sg-0064ac2eb9c706625"
  }
  type = map(string)
}


locals {
  FW_Manager_WebPublic_SG = var.FW_Manager_WebPublic_SG[terraform.workspace]
  FW_Manager_Default_SG   = var.FW_Manager_Default_SG[terraform.workspace]
}
