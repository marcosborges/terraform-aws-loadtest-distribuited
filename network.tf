data "aws_subnet" "current" {
  id = var.subnet_id
}

data "aws_vpc" "current" {
  id = data.aws_subnet.current.vpc_id
}