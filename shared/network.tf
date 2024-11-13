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
