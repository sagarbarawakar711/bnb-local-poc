resource "aws_security_group" "sep_nonprod" {
  name   = "sep_nonprod_sg"
  vpc_id = data.aws_vpc.non-default.id

  ingress {
    description     = "ZPA PROD"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-0212cd48115261d81"]

  }

  # ingress {
  #   description     = "ZPA NONPROD"
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   prefix_list_ids = ["pl-087c4faad4fe90b60"]
  # }

  ingress {
    description     = "ZPA DC"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-0b96e7cd25117e91a"]
  }

  ingress {
    description     = "ZPA DC OUT"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-0ba2643575d5227ef"]
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
    prod    = "sg-0727b8b7c34197fa6"
  }
  type = map(string)
}
variable "FW_Manager_Default_SG" {
  default = {
    nonprod = "sg-0abdfef21914622b2"
    prod    = "sg-0221fff21d1f07b58"
  }
  type = map(string)
}


locals {
  FW_Manager_WebPublic_SG = var.FW_Manager_WebPublic_SG[terraform.workspace]
  FW_Manager_Default_SG   = var.FW_Manager_Default_SG[terraform.workspace]
}
