# data "aws_subnet" "current" {
#   filter {
#     name   = "tag:Name"
#     values = ["subnet-prd-a"]
#   }
# }

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
