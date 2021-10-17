provider "aws" {
    region = var.region
    dynamic "assume_role" {
        for_each = var.assume_role_enable ? [true] : []
        content {
            role_arn    =  var.assume_role_arn
            external_id =  var.assume_role_external_id
        }
    }
}
