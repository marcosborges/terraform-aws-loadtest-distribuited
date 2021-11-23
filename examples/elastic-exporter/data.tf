data "aws_subnet" "current" {
  filter {
    name   = "tag:Name"
    values = ["subnet-prd-a"]
  }
}