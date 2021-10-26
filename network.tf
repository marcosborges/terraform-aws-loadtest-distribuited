
data "aws_vpc" "current" {
    id = var.vpc_id
}

data "aws_subnet" "current" {
    id = var.subnet_id
}